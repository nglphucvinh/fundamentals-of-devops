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