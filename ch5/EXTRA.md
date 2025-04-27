# Get your hands dirty
## Continuous Integration (CI)
1. To help catch bugs, update the GitHub Actions workflow to run a JavaScript linter, such as ESLint.
--> Update eslint.config.mjs, package.json and add the workflow for running ESLint
2. To help keep your code consistently formatted, update the workflow to run a code formatter, such as Prettier.
--> Add Prettier package, add the workflow for running Prettier
3. Update the GitHub Actions workflow to run tofu validate to check your OpenTofu code is syntactically valid and tofu fmt to ensure your code is consistently formatted.
--> Added fmt and validate in GitHub Action workflow
4. Run both tofu validate and tofu fmt as precommit hooks, so these checks run on your own computer before you can make a commit. Consider using the pre-commit framework.
--> Added pre-commit hook to format and validate OpenTofu code
5. Open up the code for the gh-actions-iam-roles module and read through it. What permissions, exactly, is the module granting to those IAM roles? Why?
--> For testing, look at `*tests*`
```
IamPermissions: "iam:CreateRole", "iam:DeleteRole", "iam:UpdateRole", "iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:PassRole", "iam:List*Role*", "iam:Get*Role*"
```
--> Why: Create temporary IAM roles needed for testing , configure these roles with appropriate policies, pass these roles to Lambda functions during tests, clean up by deleting test roles when finished, view existing roles to validate tests
```
ServerlessPermissions: "lambda:*"
```
--> Why: all permission for testing with lambda (serverless)
--> For planning, look at `*plan*`
```
IamReadOnlyPermissions: "iam:List*Role*", "iam:Get*Role*"
ServerlessReadOnlyPermissions: "lambda:Get*", "lambda:List*"
TofuStateS3ReadOnlyPermissions: "s3:Get*", "s3:List*"
```
--> Why: least privilege principle, enough for planning with OpenTofu (read-only)
--> For applying, look at `*apply*`
```
IamPermissions: "iam:CreateRole", "iam:DeleteRole", "iam:UpdateRole", "iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:PassRole", "iam:List*Role*", "iam:Get*Role*"
ServerlessPermissions: "lambda:*"
TofuStateS3Permissions: "s3:*"
TofuStateDynamoPermissions: "dynamodb:*"
```
--> Why: similar to test, but this role will have full read-write permission for s3 and dynamodb as well. This role has the most extensive permissions because it needs to actually modify AWS resources during deployment.
6. Create your own version of the `gh-actions-iam-roles` module that you can use for deploying other types of infrastructure, and not just Lambda functions: e.g., try to create IAM roles for deploying EKS clusters, EC2 instances, and so on.
--> To be done