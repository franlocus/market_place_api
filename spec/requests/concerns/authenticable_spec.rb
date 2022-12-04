require 'rails_helper'

class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe 'authenticable' do
  let!(:user) { create(:user) }
  let!(:authentication) { MockController.new }

  it 'returns user from Authorization token' do
    authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
    expect(authentication.current_user).not_to be_nil
    expect(user.id).to eq(authentication.current_user.id)
  end

  it 'doesnt return user from empty Authorization token' do
    authentication.request.headers['Authorization'] = nil

    expect(authentication.current_user).to be_nil
  end
end
