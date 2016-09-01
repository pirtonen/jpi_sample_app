require 'rails_helper'
require 'spec_helper'

RSpec.describe Micropost, type: :model do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  
  subject { @micropost }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:user) }
  it { expect(subject).to belong_to @user }
  
  it { is_expected.to be_valid }
  

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { is_expected.not_to be_valid }
  end
  
  describe "with blank content" do
    before { @micropost.content = " " }
    it { is_expected.not_to be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a". * 141 }
    it { is_expected.not_to be_valid }
  end
  
end
