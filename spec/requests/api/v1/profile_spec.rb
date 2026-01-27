require 'swagger_helper'

RSpec.describe 'api/v1/profiles', type: :request do\
  path '/api/v1/profiles/search' do
    get 'Searches users by username or full name' do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :q, in: :query, type: :string, description: 'Search term (username, first name, last name, full name, reversed full name)', required: false
      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false

      response '200', 'search results found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  # id: { type: :integer },
                  # username: { type: :string },
                  # full_name: { type: :string }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                next_page: { type: :integer, nullable: true },
                prev_page: { type: :integer, nullable: true },
                total_pages: { type: :integer },
                total_count: { type: :integer },
                per_page: { type: :integer }
              }
            }
          }

        run_test!
      end
    end
  end


  path '/api/v1/profiles/host/{user_id}' do
    get('Get Profile by Host') do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :user_id, in: :path, type: :integer, required: true

      response(200, 'successful') do
        let(:user) { User.create!(email: 'test@example.com', password: 'Password123!', username: 'testuser') }
        let(:profile) { Profile.create!(user: user, first_name: 'Test', last_name: 'User') }
        let(:user_id) { user.id }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }

        before do
          user.confirm
          profile # ensure profile exists
        end

        run_test!
      end
    end
  end

  path '/api/v1/profiles/guest/{user_id}' do
    get('Get Profile by Guest') do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :user_id, in: :path, type: :integer, required: true

      response(200, 'successful') do
        let(:user) { User.create!(email: 'guest@example.com', password: 'Password123!', username: 'guestuser') }
        let(:profile) { Profile.create!(user: user, first_name: 'Guest', last_name: 'User') }
        let(:requester) { User.create!(email: 'requester@example.com', password: 'Password123!', username: 'requester') }
        let(:user_id) { user.id }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(requester, :user, nil).first}" }

        before do
          user.confirm
          requester.confirm
          profile # ensure profile exists
        end

        run_test!
      end
    end
  end

  path '/api/v1/profiles/avatar/{user_id}' do
    get('Get Profile Avatar') do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :user_id, in: :path, type: :integer, required: true

      response(200, 'successful') do
        run_test!
      end
    end
  end





  path '/api/v1/profiles/update/{user_id}' do
    patch('Update Profile') do
      tags 'Profiles'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :user_id, in: :path, type: :integer, required: true

      parameter name: :profile, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          bio: { type: :string },
          dob: { type: :string, format: :date },
          gender: { type: :integer },
          relationship_status: { type: :integer },
          status: { type: :integer },
          allow_direct_follows: { type: :boolean },
          is_gender_public: { type: :boolean },
          is_email_public: { type: :boolean },
          is_rel_status_public: { type: :boolean }
        },
        required: [ "first_name", "last_name", "bio", "dob", "gender", "relationship_status", "status", "avatar_data", "allow_direct_follows", "is_gender_public", "is_email_public", "is_rel_status_public" ]
      }
      response(200, 'successful') do
        run_test!
      end
    end
  end


  path '/api/v1/profiles/avatar/{user_id}' do
    patch('Update Avatar') do
      tags 'Profiles'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :user_id, in: :path, type: :integer, required: true
      parameter name: :raw_avatar_data, in: :formData, schema: {
        type: :object,
        properties: {
          raw_avatar_data: { type: :string, format: :binary }
        },
        required: [ "raw_avatar_data" ]
      }

      response(200, 'successful') do
        let(:user) { User.create!(email: 'avatar_test@example.com', password: 'Password123!', username: 'avatartest') }
        let(:profile) { Profile.create!(user: user, first_name: 'Avatar', last_name: 'Test') }
        let(:user_id) { user.id }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'avatar.png'), 'image/png') }

        before do
          user.confirm
          profile
          # Mock Cloudinary upload
          allow(Cloudinary::Uploader).to receive(:upload).and_return({
            "public_id" => "test_id",
            "secure_url" => "http://res.cloudinary.com/demo/image/upload/test_id.png"
          })
        end

        run_test!
      end
    end
  end
end
