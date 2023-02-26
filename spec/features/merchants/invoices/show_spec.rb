require 'rails_helper'

describe 'As a merchant', type: :feature do
  let!(:merchant1) { create(:merchant)}

  let!(:item1) {create(:item, merchant: merchant1)}  
  let!(:item2) {create(:item, merchant: merchant1)}
  let!(:item3) {create(:item, merchant: merchant1)}
  let!(:item4) {create(:item, merchant: merchant1)}
  let!(:item5) {create(:item, merchant: merchant1)}

  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}

  let!(:invoice1) {create(:invoice, created_at: Date.new(2020, 1, 2), customer: customer1)}
  let!(:invoice2) {create(:invoice, created_at: Date.new(2019, 3, 9), customer: customer2)}

  before(:each) do
    @invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1)
    @invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2)
    @invoice_item3 = create(:invoice_item, invoice: invoice1, item: item3)
    @invoice_item4 = create(:invoice_item, invoice: invoice1, item: item4)
    @invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5)
  end

  describe "When I visit my merchant's invoice show page" do
    it 'I see the invoice ID, status, and created_at date with formatting' do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Invoice ##{invoice1.id}")
      expect(page).to_not have_content(invoice2.id)
      expect(page).to have_content("Status: #{invoice1.status}")
      expect(page).to have_content("Created on: #{invoice1.created_at.strftime("%A, %B %d, %Y")}")
    end

    it "I see the customers first and last name" do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      within "#customers" do
        expect(page).to have_content(customer1.first_name)
        expect(page).to have_content(customer1.last_name)
      end
    end

    it "I see all of my items on the invoice including: item name, quantity of item ordered, the price sold for, the invoice item status" do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Items on this invoice")
      expect(page).to have_content("Item Name")
      expect(page).to have_content("Quantity")
      expect(page).to have_content("Unit Price")
      expect(page).to have_content("Status")

      expect(page).to have_content(item1.name)
      expect(page).to have_content(@invoice_item1.quantity)
      expect(page).to have_content(@invoice_item1.unit_price)
      expect(page).to have_content(@invoice_item1.status)

      expect(page).to have_content(item2.name)
      expect(page).to have_content(@invoice_item2.quantity)
      expect(page).to have_content(@invoice_item2.unit_price)
      expect(page).to have_content(@invoice_item2.status)

      expect(page).to_not have_content(item5.name)
    end
  end
end