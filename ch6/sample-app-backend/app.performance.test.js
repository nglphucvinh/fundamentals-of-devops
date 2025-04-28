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
});
