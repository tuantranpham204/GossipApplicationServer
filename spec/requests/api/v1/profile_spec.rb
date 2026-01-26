require 'swagger_helper'

RSpec.describe 'api/v1/profiles', type: :request do
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
