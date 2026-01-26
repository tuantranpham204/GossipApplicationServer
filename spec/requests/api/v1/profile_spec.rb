require 'swagger_helper'

RSpec.describe 'api/v1/profiles', type: :request do
  path '/api/v1/profiles/host/{user_id}' do
    get('Get Profile by Host') do
      tags 'Profiles'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, required: true

      response(200, 'successful') do
        let(:user_id) { '1' }
        run_test!
      end
    end
  end

  path '/api/v1/profiles/guest/{user_id}' do
    get('Get Profile by Guest') do
      tags 'Profiles'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, required: true

      response(200, 'successful') do
        let(:user_id) { '1' }
        run_test!
      end
    end
  end
end
