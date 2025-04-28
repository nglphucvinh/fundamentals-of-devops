# Get your hands dirty
## Breaking Up Your Codebase
1. The frontend and backend both listen on port 8080. This works fine when running the apps in Docker containers, but if you wanted to test the apps without Docker, the ports will clash. Update one of the apps to listen on a different port.
--> Add PORT env for backend to listen to 8081, change container to 8081 and change targetPort in `sample-app-service.yml` to 8081
2. After all these updates, the automated tests in app.test.js for the frontend and backend are broken. Fix them.
--> Make some adjustment to use correct response text, for frontend, add mock jest dependency to mock the backend for testing
3. If the frontend’s request to the backend fails, the frontend crashes. Update it to handle errors more gracefully.
--> Add try/catch and errors.ejs to handle errors instead of generic "Internal Server Error", update app.test.js to mock failure case