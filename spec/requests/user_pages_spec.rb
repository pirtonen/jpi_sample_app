require 'rails_helper'
require 'spec_helper'

RSpec.describe "UserPages", type: :feature do
  
  subject { page }
  
  describe "Signup page" do
    before { visit signup_path }
    
    it { expect(subject).to have_selector('h1', text: 'Sign Up')}
    it { expect(subject).to have_title(full_title('Sign Up'))}

  end
end
