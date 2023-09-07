require_relative "../rails_helper"
#require "rails_helper"

RSpec.describe 'welcomeページを表示' do
	context 'rootを訪問' do
		before do
			visit root_path
		end

		it 'welcomeページを表示' do
			expect(page).to have_selector "h1", text:"イベント一覧"
		end
	end
end
