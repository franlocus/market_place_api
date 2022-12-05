require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }

  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to allow_value('example@email.com').for(:email) }
  it { is_expected.not_to allow_value('example@email', 'foo', '@').for(:email) }

  it { is_expected.to validate_presence_of(:password_digest) }
  it { is_expected.to have_many(:products).dependent(:destroy) }
end
