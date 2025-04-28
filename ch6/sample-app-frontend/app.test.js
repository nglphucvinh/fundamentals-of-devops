const request = require('supertest');
const app = require('./app');

// Set up fetch mocking
global.fetch = require('jest-fetch-mock');

describe('Test the app', () => {
  beforeEach(() => {
    fetch.resetMocks();
  });

  test('GET / should render "Hello, backend microservice!"', async () => {
    // Mock the backend response
    fetch.mockResponseOnce(JSON.stringify({ text: "backend microservice" }));

    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('backend microservice'); // Check rendered HTML
  });

  test('GET / should handle backend failure', async () => {
    // Mock a failed fetch request (network error or 500 response)
    fetch.mockRejectOnce(new Error('Backend is down'));

    const response = await request(app).get('/');
    expect(response.statusCode).toBe(502);
    expect(response.text).toContain('Could not connect to the backend');
  });
});