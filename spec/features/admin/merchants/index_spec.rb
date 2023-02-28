require 'rails_helper'

RSpec.describe 'admin merchants index page' do
	let!(:merchant_1) { create(:active_merchant) }
	let!(:merchant_2) { create(:active_merchant) }
	let!(:merchant_3) { create(:active_merchant) }


	describe 'shows all merchants' do
		it 'shows all merchants' do
			visit "/admin/merchants"

			expect(page).to have_content('Merchants List')
			
			within "#merchant-list" do
				within "##{merchant_1.id}" do
					expect(page).to have_content(merchant_1.name)
					expect(page).to have_content('Status: active')
				end
				within "##{merchant_2.id}" do
					expect(page).to have_content(merchant_2.name)
					expect(page).to have_content('Status: active')
				end
				within "##{merchant_3.id}" do
					expect(page).to have_content(merchant_3.name)
					expect(page).to have_content('Status: active')
				end
			end
		end
	end

	describe 'link to admin/merchant show page' do
		it 'has links on all merchants in admin/merchants to each merchant index' do
			visit "/admin/merchants"

			within "#merchant-list" do
				expect(page).to have_link("#{merchant_1.name}", href: admin_merchant_path(merchant_1))
				expect(page).to have_link("#{merchant_2.name}", href: admin_merchant_path(merchant_2))
				expect(page).to have_link("#{merchant_3.name}", href: admin_merchant_path(merchant_3))
			end
		end

		it 'takes me to admin/merchant show page and I see the merchant name' do
			visit admin_merchants_path

			click_link "#{merchant_1.name}"

			expect(current_path).to eq(admin_merchant_path(merchant_1))
			expect(page).to have_content("#{merchant_1.name}")
			expect(page).to_not have_content("#{merchant_2.name}")
		end
	end

	describe 'admin merchant enable/disable' do
		it 'has a button next to each merchant to disable merchant' do
			visit admin_merchants_path

			within "##{merchant_1.id}" do
				expect(page).to have_button('Disable')
			end

			within "##{merchant_2.id}" do
				expect(page).to have_button('Disable')
			end
		end

		it 'changes status of merchant to disabled when disable button is clicked' do
			visit admin_merchants_path
			
			expect(page).to have_content("#{merchant_1.name}\nStatus: active")

			within "##{merchant_1.id}" do
				click_button 'Disable'
			end
			
			expect(current_path).to eq(admin_merchants_path)
			expect(page).to have_content("#{merchant_1.name}\nStatus: disabled")
		end

		it 'changes status of merchant to enabled when enable button is clicked' do
			visit admin_merchants_path

			within "##{merchant_1.id}" do
				expect(page).to have_button('Disable')
				click_button 'Disable'
				expect(page).to have_button('Enable')
			end
			
			expect(page).to have_content("#{merchant_1.name}\nStatus: disabled")

			within "##{merchant_1.id}" do
				click_button 'Enable'
			end

			expect(current_path).to eq(admin_merchants_path)
			expect(page).to have_content("#{merchant_1.name}\nStatus: active")
		end

		it 'will have a link to create a new merchant' do 
			visit admin_merchants_path

			expect(page).to have_link("Create New Merchant")
			click_on "Create New Merchant"

			expect(page).to have_current_path('/admin/merchants/new')
		end
	end
end