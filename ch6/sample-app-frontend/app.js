const express = require('express');
const app = express();

app.set('view engine', 'ejs');

const backendHost = 'http://sample-app-backend-service'; 

app.get('/', async (req, res) => {
  try {
    // 1. Send request to backend
    const response = await fetch(backendHost);       
    
    // 2. Check if the response is successful (status 200-299)
    if (!response.ok) {
      throw new Error(`Backend request failed with status ${response.status}`);
    }

    // 3. Render as normal
    const responseBody = await response.json();            
    res.render('hello', {name: responseBody.text}); 
  } catch (error) {
    // 4. Now handle errors
      res.status(502).render('error', { 
      message: 'Could not connect to the backend. Please try again later.'
    });
  }
});

module.exports = app;