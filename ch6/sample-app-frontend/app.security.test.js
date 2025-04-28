const request = require('supertest');
const app = require('./app');

describe('Security Tests', () => {
  test('Should handle non-existent routes', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.statusCode).toBe(404);
  });
});
