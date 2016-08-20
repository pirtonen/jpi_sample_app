require 'rails_helper'
require 'spec_helper'

RSpec.describe "Static Pages", type: :feature do
  
  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    
    it { expect(subject).to have_selector('h1', :text => 'Sample App') }
    it { expect(subject).to have_title(full_title('')) }

  end

  describe "Help page" do
    before { visit help_path }
    
    it { expect(subject).to have_selector('h1', :text => 'Help') }
    it { expect(subject).to have_title(full_title('Help')) }

  end

  describe "About page" do
    before { visit about_path }
    
    it { expect(subject).to have_selector('h1', :text => 'About Us') }
    it { expect(subject).to have_title(full_title('About Us')) }
    
  end

  describe "Contact page" do
    before { visit contact_path }
    
    it { expect(subject).to have_selector('h1', :text => 'Contact') }
    it { expect(subject).to have_title(full_title('Contact')) }
    
  end
    
end
