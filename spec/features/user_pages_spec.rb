require 'rails_helper'
require 'spec_helper'

RSpec.describe "User Pages", type: :feature do
  
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      sign_in user
      visit users_path
    end
    
    it { expect(subject).to have_title('All users') }
    it { expect(subject).to have_selector('h1', text: 'All users') }

    describe "pagination" do
      it { expect(subject).to have_selector('div.pagination') }
      
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(subject).to have_selector('li', text: user.name)
        end
      end
    end
  end
  
  describe "delete links" do
    it { expect(subject).not_to have_link('delete') }
    
    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end
      
      it { expect(subject).to have_link('delete', href: user_path(User.first)) }
      it "should be able to delete another user" do
        expect { click_link('delete') }.to change(User, :count).by(-1)
      end
      it { expect(subject).not_to have_link('delete', href: user_path(admin)) }
    end
  end
  
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
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { expect(subject).to have_selector('h1', text: "Update your profile") }
      it { expect(subject).to have_title("Edit user") }
      it { expect(subject).to have_link('change', href: 'http://gravatar.com/emails') }
    end
    
    describe "with invalid information" do
      before do
        fill_in "Name", with: " "
        click_button "Save changes"
      end
      
      it { expect(subject).to have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      
      it { expect(subject).to have_title(new_name) }
      it { expect(subject).to have_selector('div.alert.alert-success') }
      it { expect(subject).to have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq(new_name) }
      specify { expect(user.reload.email).to eq(new_email) }
    end
  end
end
