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
    let(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
    
    before { visit user_path(user) }
    
    it { expect(subject).to have_selector('h1', text: user.name) }
    it { expect(subject).to have_title(user.name) }
    
    describe "microposts" do
      it { expect(subject).to have_content(m1.content) }
      it { expect(subject).to have_content(m2.content) }
      it { expect(subject).to have_content(user.microposts.count) }
    end
    
    describe "follow/unflow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "following a user" do
        before { visit user_path(other_user) }
        
        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
        
        describe "toggling the button" do
          before { click_button "Follow" }
          it { expect(subject).to have_selector('input', value: 'Unfollow') }
        end
      end
      
      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        
        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
 
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { expect(subject).to have_selector('input', value: 'Follow') }
        end       
      end
    end
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
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }
    
    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      
      it { expect(subject).to have_title(full_title('Following')) }
      it { expect(subject).to have_selector('h3', text: 'Following') }
      it { expect(subject).to have_link(other_user.name, href: user_path(other_user)) }
    end
    
    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      
      it { expect(subject).to have_title(full_title('Followers')) }
      it { expect(subject).to have_selector('h3', text: 'Followers') }
      it { expect(subject).to have_link(user.name, href: user_path(user)) }
    end
  end
end
