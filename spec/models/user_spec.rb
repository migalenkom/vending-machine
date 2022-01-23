require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:seller_user) }

  it 'should update deposit' do
    expect { user.update(deposit: 5) }.to change { user.deposit }
  end
end
