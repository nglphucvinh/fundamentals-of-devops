const request = require('supertest');
const app = require('./app');

describe('Test the app', () => {
  test('Get / should return backend microservice', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({ text: "backend microservice" }); // Check full JSON
  });
});
