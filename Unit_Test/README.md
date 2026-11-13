# Simulation Unit Testing Assignment

## Student information

- **Name:** [Enter your full name]
- **Group / ID:** [Enter your group and ID]

> Replace the two placeholders above before submission.

## Submission content

This repository contains the original Mini Checkout Engine production code and the test suite for Tasks 1–5. The production code under `src/` is unchanged.

### Test files

- `tests/Simulation.Checkout.Tests/CheckoutServiceTests.cs` — Tasks 1 and 2: business rules and Moq interactions.
- `tests/Simulation.Checkout.Tests/TestData/` — Task 3: AutoFixture, Bogus, shared test data, and harness.
- `tests/Simulation.Checkout.Tests/ReceiptSnapshotTests.cs` and its `.verified.txt` file — Task 4.
- `tests/Simulation.Checkout.Tests/ArchitectureTests.cs` — Task 5.
- `TESTING_NOTES.md` — submission answers and coverage instructions.

## Run the tests

Requires the .NET 10 SDK:

```bash
dotnet restore
dotnet test
```

## Generate the coverage report

Run from the repository root:

```bash
dotnet test --collect:"XPlat Code Coverage" --results-directory ./TestResults
dotnet tool install -g dotnet-reportgenerator-globaltool
reportgenerator -reports:"./TestResults/**/coverage.cobertura.xml" -targetdir:"coverage-report" -reporttypes:"Html;TextSummary"
```

The assignment requires at least 80% line coverage for Domain and Application. Commit `coverage-report/` after generating it. Do not commit `bin/`, `obj/`, `TestResults/`, or any `.received.txt` file.

## Git submission reminder

Create the branch using the exact name shown on the Simulation Academy website, commit as you go with meaningful messages, and open the Pull Request using the exact title shown there. Those values are not included in the starter ZIP, so do not substitute guessed names.
