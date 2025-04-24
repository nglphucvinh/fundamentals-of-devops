# Get your hands dirty
## Automated Testing
1. Try creating other types of automated tests for the Node.js app: e.g., static analysis, unit tests, performance tests (the Chapter 4 Learning Resources may help).
--> Adđe pẻomance, security, eslint
2. Add the --coverage flag to the jest command to enable code coverage, which will show you what percent of your code is executed by your automated tests. If it’s only, say, 20%, how much confidence can you have in your test suite?
--> Little confidence, 80% of the code is completely untested by automated tests, may have hidden issues and errors we may not know.
3. Add other types of tests for your OpenTofu code: e.g., static analysis (Terrascan), policy enforcement (OPA), and integration tests (Terratest).
--> Install terrascan and run, add config if needed (terrascan.toml)
```
brew install terrascan
cd <path> && terrascan scan
```
--> Install OPA, config policy `lambda_policy.rego` and ru
```
opa eval --format pretty --data lambda_policy.rego --input plan.json "data.terraform.deny"
```
--> Install latest go version and create go test file
```
brew install go
mkdir -p test
cd test
go mod init lambda_test
vim lambda_test.go
go mod tidy
go test -v -timeout 30m
```
4. Add a new endpoint in your lambda module and add a new automated test to validate the endpoint works as expected.