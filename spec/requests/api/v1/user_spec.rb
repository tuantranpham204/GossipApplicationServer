# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/api/v1/users/me' do

    patch('Change User Langue') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      # Define the input parameter
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              locale: { type: :string }
            },
            required: [ "locale" ]
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