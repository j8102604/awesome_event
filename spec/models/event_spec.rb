require_relative '../rails_helper'

RSpec.describe Event, type: :model do
	describe '制約の確認' do
		before do
			FactoryBot.create(:event)
		end

		it '入力必須の確認' do
			is_expected.to validate_presence_of :name
			is_expected.to validate_presence_of :place
			is_expected.to validate_presence_of :content
			is_expected.to validate_presence_of :start_at
			is_expected.to validate_presence_of :end_at
		end

		it '文字数制限の確認' do
			should validate_length_of(:name).is_at_most(50)
			should validate_length_of(:place).is_at_most(100)
			should validate_length_of(:content).is_at_most(2000)
		end

		it '' do
		end
	end
end
