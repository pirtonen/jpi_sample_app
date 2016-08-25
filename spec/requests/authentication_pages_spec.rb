require 'rails_helper'

RSpec.describe "Authentication", type: :feature do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { expect(subject).to have_title("Sign in") }
      it { expect(subject).to have_selector('div.alert.alert-error', :text => "Invalid") }

      describe "after visiting another page" do
        before { click_link 'Home' }
        
        it { expect(subject).not_to have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",       with: user.email
        fill_in "Password",    with: user.password
        click_button "Sign in"
      end
      
      it { expect(subject).to have_title(user.name) }
      it { expect(subject).to have_link('Profile', href: user_path(user)) }
      it { expect(subject).to have_link('Sign out', href: signout_path) }
      it { expect(subject).not_to have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        
        it { expect(subject).to have_link('Sign in') }
      end
    end
  end
end
