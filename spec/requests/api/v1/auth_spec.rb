require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  # Grouping: This creates a folder in the UI called "Authentication"
  path '/api/v1/users/sign_in' do

    post('Sign In') do
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
              email_or_username: { type: :string },
              password: { type: :string }
            },
            required: %w[email_or_username password]
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

    post('Sign Up') do
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
              username: { type: :string },
              email: { type: :string, default: "string@string.string" },
              password: { type: :string },
              password_confirmation: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              gender: { type: :integer, default: 1 }
            },
            required: %w[username email password password_confirmation first_name last_name gender]
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
  path '/api/v1/users/confirmation' do
    get('Confirm Account') do
      tags 'Authentication'
      produces 'text/html'
      parameter name: :confirmation_token, in: :query, type: :string, required: true

      response(302, 'redirected') do
        run_test!
      end

      response(422, 'invalid token') do
        run_test!
      end
    end
  end
end
