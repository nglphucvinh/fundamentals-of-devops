package test

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestLambdaEndpoints validates that both the root and health endpoints work
func TestLambdaEndpoints(t *testing.T) {
	// Arrange
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	// Act - Deploy infrastructure
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Get the function URL from the outputs
	functionUrl := terraform.Output(t, terraformOptions, "function_url")

	// Wait for function to be fully deployed and available
	time.Sleep(15 * time.Second)

	// Assert - Test root endpoint
	t.Run("Root Endpoint", func(t *testing.T) {
		response, err := http.Get(functionUrl)
		assert.NoError(t, err)
		assert.Equal(t, 200, response.StatusCode)

		body, err := ioutil.ReadAll(response.Body)
		assert.NoError(t, err)

		// Verify the response contains expected text
		assert.Equal(t, "Hello, World!", string(body))
	})

	// Test health endpoint
	t.Run("Health Endpoint", func(t *testing.T) {
		healthUrl := functionUrl
		if healthUrl[len(healthUrl)-1:] != "/" {
			healthUrl += "/health"
		} else {
			healthUrl += "health"
		}

		response, err := http.Get(healthUrl)
		assert.NoError(t, err)
		assert.Equal(t, 200, response.StatusCode)

		body, err := ioutil.ReadAll(response.Body)
		assert.NoError(t, err)

		var result map[string]interface{}
		err = json.Unmarshal(body, &result)
		assert.NoError(t, err)

		// Verify the response contains expected fields
		assert.Contains(t, result, "status")
		assert.Equal(t, "healthy", result["status"])
		assert.Contains(t, result, "timestamp")
	})
}
