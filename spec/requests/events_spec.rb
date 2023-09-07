require_relative "../rails_helper"

RSpec.describe "Events", type: :request do
	xdescribe 'サインインしていない場合、showのみ機能する' do
		context 'showの場合' do
			before do
				@event = FactoryBot.create(:event)
				get event_path(@event)
			end

			it '機能する' do
				should render_template('show')
				expect(response.body).to include(@event.name)
			end
		end
		
		context 'newの場合' do
			before do
				get new_event_path
			end

			it '機能しない' do
				expect(response.status).to eq 302
#				should respond_with(302)
				should redirect_to('/')
#				should set_flash[:alert] 
			end
		end
	end

	describe 'サインインしている場合すべて機能する' do
		before do
			@event_owner = FactoryBot.create(:user)
			sign_in_as(@event_owner)
		end

		xcontext 'show' do
			before do
				event = FactoryBot.create(:event, owner: @event_owner)
				get event_path(event)
			end

			it '機能する' do
				should render_template('show')
				expect(response.status).to eq 200
			end
		end

		context 'new' do
			before do
				get new_event_path
			end

			it '機能する' do
				should render_template('new')
				expect(response.status).to eq 200
			end
		end
	end
end
