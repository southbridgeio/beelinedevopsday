# == Schema Information
#
# Table name: pastes
#
#  id                 :integer          not null, primary key
#  body               :text(16777215)
#  request_info       :text(16777215)
#  permalink          :text(16777215)
#  language           :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  auto_destroy       :boolean          default(FALSE), not null
#  will_be_deleted_at :datetime
#
require 'rails_helper'

RSpec.describe 'pastes', type: :request do
  let!(:paste) { create :paste }

  it do
    get pastes_path

    expect(response).to have_http_status 302
  end

  it do
    get root_path

    expect(response).to be_successful
  end

  it 'should create paste' do
    expect { post pastes_path, params: { paste: attributes_for(:paste) } }.to change { Paste.count }
    expect(response).to redirect_to paste_path(Paste.last)
  end

  it 'should not raise error if empty params' do
    expect { post pastes_path }.to_not raise_error
  end

  it 'should show paste' do
    get paste_path(paste)

    expect(response).to be_successful
  end

  it 'should get edit' do
    get edit_paste_path(paste)

    expect(response).to redirect_to paste_url(paste)
  end

  it 'should update paste' do
    patch paste_path(paste), params: { paste: attributes_for(:paste) }

    expect(response).to redirect_to paste_path(Paste.last)
  end

  it 'should destroy paste' do
    expect { delete paste_path(paste) }.to change { Paste.count }
  end

  xit 'should soft delete paste' do
    delete paste_path(paste)
    expect(Paste.only_deleted.size).to eq 1
    expect(paste.reload.deleted_at).to_not eq nil
  end

  describe 'invalid locale' do
    it 'should render locale error' do
      get new_paste_path, params: { locale: 'Fake locale' }

      expect(response.body).to include 'Unsupported locale. Available locale is ru/en'
    end
  end
end
