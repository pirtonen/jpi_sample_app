require 'rails_helper'
require 'spec_helper'

RSpec.describe "Static Pages", type: :feature do
  
#  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  describe "Home page" do
    
    it "should have the h1 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_selector('h1', :text => 'Sample App')
    end

    it "should have the base title" do
      visit 'static_pages/home'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end
    
    it "should not have a custom title" do
      visit 'static_pages/home'
      expect(page).to have_no_title("| Home")
    end
  end

  describe "Help page" do
    
    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit 'static_pages/help'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end
 
    it "should not have a custom title" do
      visit 'static_pages/help'
      expect(page).to have_no_title("| Help")
    end 
  end

  describe "About page" do
    
    it "should have the h1 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About >Us'" do
      visit 'static_pages/about'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "should not have a custom title" do
      visit 'static_pages/about'
      expect(page).to have_no_title("| About Us")
    end
    
  end

  describe "Contact page" do
    
    it "should have the h1 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_selector('h1', :text => 'Contact')
    end

    it "should have the title 'Contact'" do
      visit 'static_pages/contact'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "should not have a custom title" do
      visit 'static_pages/contact'
      expect(page).to have_no_title("| Contact")
    end
    
  end
    
end
