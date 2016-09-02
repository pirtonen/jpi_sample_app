require 'rails_helper'

RSpec.describe "Relationship Controller", type: :feature do
    
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    
    before { sign_in user }
    
    describe "creating a relationship with Ajax" do
        
        it "should increment the Relationship count" do
            expect { xhr :post, :create, relationship: { followed_id: other_user.id }}.to change(Relationship, :count).by(1)
        end
        
        it "should respond to success" do
             xhr :post, :create, relationship: { followed_id: other_user.id }
             expect(response).to be_success
        end
    end

    describe "destroying a relationship with Ajax" do
        
        before { user.follow!(other_user) }
        let(:relationship) { user.relationships.find_by_followed_id(other_user) }
        
        it "should decrement the Relationship count" do
            expect { xhr :delete, :destroy, id: relationship.id }.to hange(Relationship, :count).by(-1)
        end
        
        it "should respond with success" do
             xhr :delete, :destroy, id: relationship.id
             expect(response).to be_success
        end
    end
end