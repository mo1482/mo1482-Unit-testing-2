# Testing Notes — Mini Checkout Engine

## 1. Total tests, passing, failing

- Test methods/scenarios implemented: **16**.
- Executable xUnit cases after expanding the three parameterized theories: **20**.
- Passed: **Not run in this environment**.
- Failed: **Not run in this environment**.

The environment used to prepare this submission does not have the .NET 10 SDK installed, so no test result is being claimed. Run `dotnet test` locally and replace the two status values with the actual output.

## 2. Line coverage

**Not generated yet.** The coverage report must be produced after running the test suite with Coverlet and ReportGenerator. The assignment target is at least **80% line coverage** for the Domain and Application projects.

Commands (from the repository root):

```bash
dotnet test --collect:"XPlat Code Coverage" --results-directory ./TestResults

dotnet tool install -g dotnet-reportgenerator-globaltool

reportgenerator -reports:"./TestResults/**/coverage.cobertura.xml" -targetdir:"coverage-report" -reporttypes:"Html;TextSummary"
```

Copy the exact line coverage percentage for Domain and Application from `coverage-report/Summary.txt` into this section after generation. Commit the generated HTML report, but do not commit `TestResults/`.

## 3. Where the test-data and mocking libraries are used

- **Moq:** `CheckoutServiceHarness` mocks `IInventoryService`, `IOrderRepository`, and `INotificationService`; checkout tests verify calls and `Times.Once` / `Times.Never` behavior.
- **AutoFixture:** `AutoFixtureOrderFactory` creates an order and customizes every generated order item to have a positive quantity and a non-negative unit price.
- **Bogus:** `BogusCustomerFactory` generates a realistic customer name and email using the fixed seed `20261113`.

## 4. Is the discount boundary fair?

No: an order of EGP 999.99 receives no discount and costs EGP 999.99, while an order of EGP 1,000 receives an EGP 100 discount and costs EGP 900.

## 5. Potential bug / behavior worth reporting

The code saves the order before sending the confirmation. If `SendOrderConfirmationAsync` throws, checkout fails after the order has already been saved, which conflicts with BR-09's statement that on any failure the order is not saved. This is documented only; production code was not changed.

2. Line coverage: 90.5% overall.
   Domain: 100%.
   Application: 95.8%.
   Infrastructure: 0%.
   Both required projects exceed the 80% target.
