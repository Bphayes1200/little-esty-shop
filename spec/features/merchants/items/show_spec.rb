require 'rails_helper'

RSpec.describe 'merchant items show page', type: :feature do
  describe "as a merchant, when I visit my merchant index page ('/merchant/merchant_id/items')" do
    let!(:merchant1) { create(:merchant)}

    let!(:item1) {create(:item, merchant: merchant1)}  
    let!(:item2) {create(:item, merchant: merchant1)}
    let!(:item3) {create(:item, merchant: merchant1)}
    let!(:item4) {create(:item, merchant: merchant1)}

    it "I see a list of the names of all the items and do not see other merchant items" do
      visit "/merchants/#{merchant1.id}/items"

      click_on "#{item1.name}"
      
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/#{item1.id}")
      expect(page).to have_content(item1.name)
      expect(page).to have_content("Description: #{item1.description}")
      expect(page).to have_content("Price: #{item1.unit_price}")
    end
  end
end