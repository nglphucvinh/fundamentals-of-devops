exports.handler = (event, context, callback) => {
  // Parse the path from the event
  const path = event.rawPath || '/';
  
  // Route based on the path
  if (path === '/health') {
    callback(null, {
      statusCode: 200, 
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: 'healthy', timestamp: new Date().toISOString() })
    });
  } else {
    // Original endpoint behavior
    callback(null, {
      statusCode: 200, 
      body: "Hello, World!"
    });
  }
};