require 'rails_helper'

RSpec.describe Cron::Paste::DeleteJob do
  subject { described_class.perform_async }

  let!(:pastes_for_delete)     { create_list(:paste, 3, will_be_deleted_at: Time.now) }
  let!(:pastes_for_delete2)    { create_list(:paste, 3, will_be_deleted_at: Time.now - 1.day) }
  let!(:pastes_feature_delete) { create(:paste, will_be_deleted_at: Time.now + 1.day) }

  it 'should delete all with will_be_deleted_at time <= Time.now' do
    subject
    expect(Paste.all).to match_array [pastes_feature_delete]
  end
end
