const request = require('supertest');
const app = require('./app');

describe('Security Tests', () => {
  test('Should handle URL encoding attacks', async () => {
    const response = await request(app).get('/name/%3Cscript%3Ealert(%22xss%22)%3C%2Fscript%3E');
    expect(response.statusCode).toBe(200);
    expect(response.text).not.toContain('<script>alert("xss")</script>');
    expect(response.text).toContain('&lt;script&gt;');
  });

  test('Should handle long input names', async () => {
    const longName = 'a'.repeat(1000);
    const response = await request(app).get(`/name/${longName}`);
    expect(response.statusCode).toBe(200);
  });

  test('Should handle special characters in names', async () => {
    const specialChars = '!@#$%^&*()_+-=[]{}|;:,.<>?';
    const response = await request(app).get(`/name/${specialChars}`);
    expect(response.statusCode).toBe(200);
  });

  test('Should handle non-existent routes', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.statusCode).toBe(404);
  });
});
