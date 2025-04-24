package test

import (
	"net/http"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestLambdaModule(t *testing.T) {
	// Arrange
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		// Or use override values only for existing variables if needed
		// Vars: map[string]interface{}{
		// 	"name": "lambda-test",
		// },
	})

	// Act - Deploy infrastructure
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assert - Verify function URL works
	functionUrl := terraform.Output(t, terraformOptions, "function_url")

	// Wait for function to be available
	time.Sleep(10 * time.Second)

	// Test the endpoint
	response, err := http.Get(functionUrl)
	assert.NoError(t, err)
	assert.Equal(t, 200, response.StatusCode)
}
