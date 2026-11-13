$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $root

try {
    $solution = Join-Path $root 'Simulation.Checkout.slnx'
    $resultsDirectory = Join-Path $root 'TestResults'
    $coverageDirectory = Join-Path $root 'coverage-report'

    if (-not (Test-Path $solution)) {
        throw "Solution file not found: $solution"
    }

    Write-Host "Using .NET SDK:" -ForegroundColor Cyan
    & dotnet --version
    if ($LASTEXITCODE -ne 0) {
        throw '.NET SDK is unavailable. Install the .NET 10 SDK first.'
    }

    if (Test-Path $resultsDirectory) {
        Remove-Item $resultsDirectory -Recurse -Force
    }
    New-Item -ItemType Directory -Path $resultsDirectory -Force | Out-Null
    New-Item -ItemType Directory -Path $coverageDirectory -Force | Out-Null

    Write-Host "`nRunning tests and collecting coverage..." -ForegroundColor Cyan
    & dotnet test $solution --collect:'XPlat Code Coverage' --results-directory $resultsDirectory --logger 'console;verbosity=normal'
    if ($LASTEXITCODE -ne 0) {
        throw 'Tests failed. Fix the test failures before generating/submitting coverage.'
    }

    $coverageFiles = @(Get-ChildItem -Path $resultsDirectory -Filter 'coverage.cobertura.xml' -Recurse -File)
    if ($coverageFiles.Count -eq 0) {
        throw "No coverage.cobertura.xml was generated under $resultsDirectory. Confirm coverlet.collector is referenced by the test project."
    }

    Write-Host "`nChecking ReportGenerator..." -ForegroundColor Cyan
    $globalToolList = (& dotnet tool list --global | Out-String)
    if ($globalToolList -match 'dotnet-reportgenerator-globaltool') {
        & dotnet tool update --global dotnet-reportgenerator-globaltool
    }
    else {
        & dotnet tool install --global dotnet-reportgenerator-globaltool
    }
    if ($LASTEXITCODE -ne 0) {
        throw 'Could not install/update ReportGenerator.'
    }

    $reportGeneratorExe = Join-Path $HOME '.dotnet\tools\reportgenerator.exe'
    if (Test-Path $reportGeneratorExe) {
        $reportGenerator = $reportGeneratorExe
    }
    else {
        $reportGeneratorCommand = Get-Command 'reportgenerator' -ErrorAction SilentlyContinue
        if ($null -eq $reportGeneratorCommand) {
            throw 'ReportGenerator was installed but its executable could not be found. Open a new PowerShell window and run this script again.'
        }
        $reportGenerator = $reportGeneratorCommand.Source
    }

    Write-Host "`nGenerating HTML and text summary..." -ForegroundColor Cyan
    $reportArguments = @(
        "-reports:$resultsDirectory\**\coverage.cobertura.xml",
        "-targetdir:$coverageDirectory",
        '-reporttypes:Html;TextSummary'
    )
    & $reportGenerator @reportArguments
    if ($LASTEXITCODE -ne 0) {
        throw 'ReportGenerator failed.'
    }

    $summaryPath = Join-Path $coverageDirectory 'Summary.txt'
    $htmlPath = Join-Path $coverageDirectory 'index.html'

    if (Test-Path $summaryPath) {
        Write-Host "`n===== Coverage Summary =====" -ForegroundColor Green
        Get-Content $summaryPath
    }
    else {
        Write-Warning "Summary.txt was not found at $summaryPath. Inspect the generated report directory."
    }

    if (Test-Path $htmlPath) {
        Write-Host "`nHTML report: $htmlPath" -ForegroundColor Green
    }

    Write-Host "`nAll tests passed and the coverage report was generated." -ForegroundColor Green
    Write-Host 'Now copy the actual test counts and Domain/Application line coverage percentages into TESTING_NOTES.md.'
    Write-Host 'Commit coverage-report/, but do NOT commit TestResults/, bin/, obj/, or any *.received.txt file.'
}
catch {
    Write-Error $_
    exit 1
}
finally {
    Pop-Location
}
