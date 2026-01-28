require 'rails_helper'

RSpec.describe AvatarUploadJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:raw_avatar_data) { "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==" }

  it "queues the job" do
    expect {
      AvatarUploadJob.perform_later(user.id, raw_avatar_data)
    }.to have_enqueued_job(AvatarUploadJob)
      .with(user.id, raw_avatar_data)
      .on_queue("default")
  end

  it "uploads the avatar and updates the profile" do
    allow(Cloudinary::Uploader).to receive(:upload).and_return({
      "public_id" => "new_id",
      "secure_url" => "http://example.com/new_avatar.png"
    })

    allow(Cloudinary::Api).to receive(:delete_resources)

    perform_enqueued_jobs do
      AvatarUploadJob.perform_later(user.id, raw_avatar_data)
    end

    profile.reload
    expect(profile.avatar_data["public_id"]).to eq("new_id")
    expect(profile.avatar_data["url"]).to eq("http://example.com/new_avatar.png")
  end
end
