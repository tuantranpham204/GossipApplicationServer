require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  # Grouping: This creates a folder in the UI called "Authentication"
  path '/api/v1/users/sign_in' do

    post('Login User') do
      tags 'Authentication' # <--- This groups it in the UI
      consumes 'application/json'
      produces 'application/json'

      # Define the input parameter
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        }
      }

      response(200, 'successful') do
        # This captures the actual response from your API for the example
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        run_test!
      end
    end
  end


  path '/api/v1/users/sign_up' do

    post('Register User') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      # Define the input parameter
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          }
        }
      }

      response(200, 'successful') do
        # This captures the actual response from your API for the example
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        run_test!
      end
    end
  end
end
