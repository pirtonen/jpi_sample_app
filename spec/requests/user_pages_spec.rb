require 'rails_helper'
require 'spec_helper'

RSpec.describe "User Pages", type: :feature do
  
  subject { page }
  
  describe "Signup page" do
    before { visit signup_path }
    
    it { expect(subject).to have_selector('h1', text: 'Sign Up') }
    it { expect(subject).to have_title(full_title('Sign Up')) }

  end
  
  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { expect(subject).to have_selector('h1', text: user.name) }
    it { expect(subject).to have_title(user.name) }
    
  end  

  describe "singup" do
    before { visit signup_path }
    
    let(:submit) { "Create my account" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button "Create my account" }
        
        it { expect(subject).to have_title("Sign Up") }
        it { expect(subject).to have_content("error") }

      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",               with: "Example User"
        fill_in "Email",              with: "user@example.user"
        fill_in "Password",           with: "foobar"
        fill_in "Confirmation",       with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button "Create my account" }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button "Create my account" }
        let(:user) { User.find_by_email('user@example.user') }
        
        it { expect(subject).to have_title(user.name) }
        it { expect(subject).to have_selector('div.alert.alert-success', text: "Welcome") }
        it { expect(subject).to have_link('Sign out') }
      end
    end
    
  end
  
end
