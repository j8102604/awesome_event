require_relative "../rails_helper"

RSpec.describe '退会について' do
	before do
		@myself = FactoryBot.create(:user)
		sign_in_as(@myself)
		visit root_path
		click_on '退会'
	end

	it '退会ボタンを押下すると確認画面が表示される' do
		expect(page).to have_selector "h1", text: '退会の確認'
	end

	context '「退会する」ボタンを押下した場合' do
		it 'ユーザー情報が削除される' do
			expect do
				click_on '退会する'
				page.accept_confirm
				sleep(1)
			end.to change(User, :count).by(-1)
		end
	end

	context '未終了のイベント(自身主催)がある状態で「退会する」を押下した場合' do
		before do
		end

		it '退会できない' do
		end
	end

	context '未終了のイベント(参加予定)がある状態で「退会する」を押下した場合' do
		before do
		end

		it '退会できない' do
		end
	end
end
