const request = require('supertest');
const app = require('./app');

describe('Performance Tests', () => {
  test('Root endpoint should respond within 50ms', async () => {
    const start = Date.now();
    await request(app).get('/');
    const end = Date.now();
    const responseTime = end - start;
    expect(responseTime).toBeLessThan(50);
  });

  test('Name endpoint should respond within 50ms', async () => {
    const start = Date.now();
    await request(app).get('/name/Bob');
    const end = Date.now();
    const responseTime = end - start;
    expect(responseTime).toBeLessThan(50);
  });

  test('Should handle multiple concurrent requests', async () => {
    const start = Date.now();
    
    // Create an array of 10 concurrent requests
    const requests = Array(10).fill().map(() => 
      request(app).get('/name/Bob')
    );
    
    // Wait for all requests to complete
    const responses = await Promise.all(requests);
    
    const end = Date.now();
    const totalTime = end - start;
    
    // All responses should be successful
    responses.forEach(response => {
      expect(response.statusCode).toBe(200);
    });
    
    // Total time for 10 requests should be reasonable
    // (adjust threshold as needed based on your environment)
    expect(totalTime).toBeLessThan(500);
  });
});