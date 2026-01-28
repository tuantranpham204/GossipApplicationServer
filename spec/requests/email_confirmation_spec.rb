require 'rails_helper'

RSpec.describe 'Emails', type: :request do
  include ActiveJob::TestHelper

  describe 'POST /api/v1/users/sign_up' do
    let(:url) { '/api/v1/users/sign_up' }
    let(:params) do
      {
        user: {
          username: 'sometestname',
          email: 'testemail@example.com',
          password: 'Password123!',
          first_name: 'Test',
          last_name: 'User',
          gender: 1,
          dob: '2000-01-01'
        }
      }
    end

    it 'enqueues a confirmation email' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        post url, params: params
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)

      expect(response).to have_http_status(:success)
    end
  end
end
