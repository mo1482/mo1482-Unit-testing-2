# Checklist Before Pull Request

- [ ] Replace the Name and Group / ID placeholders in `README.md`.
- [ ] Copy the exact branch name from the Simulation Academy website and create that branch; do not commit to `main`.
- [ ] Run `dotnet restore` and `dotnet test` with the .NET 10 SDK; confirm all 20 xUnit cases pass.
- [ ] Review the generated Verify snapshot and confirm all Example C values before committing the `.verified.txt` file.
- [ ] Run Coverlet and ReportGenerator using the commands in `TESTING_NOTES.md`.
- [ ] Confirm line coverage is at least 80% for Domain and Application, then commit the generated `coverage-report/` HTML output.
- [ ] Fill in the actual pass/fail counts and coverage percentage in `TESTING_NOTES.md`.
- [ ] Confirm no file under `src/` has changed.
- [ ] Confirm `bin/`, `obj/`, `TestResults/`, and all `.received.txt` files are not committed.
- [ ] Commit each task with a meaningful commit message.
- [ ] Open the Pull Request into `main` using the exact title copied from the Simulation Academy website.
