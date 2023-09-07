require_relative "../rails_helper"

RSpec.describe 'イベントについて' do
	describe 'イベント一覧を表示' do
		before do
			visit root_path
		end

		context 'ログインしてない場合' do
			it '上部のボタンの確認' do
				expect(page).to have_link "イベントを作る"
				expect(page).to have_link "GitHubでログイン"
			end
		end

		context 'ログインしている場合' do
			before do
				sign_in_as(FactoryBot.create(:user))
			end

			it '上部のボタンの確認' do
				expect(page).to have_link "イベントを作る"
				expect(page).to have_link "ログアウト"
				expect(page).to have_link "退会"
			end
		end

		context '通常処理,ページネーションはしない' do
			it 'イベント一覧を表示' do
				expect(page).to have_selector "h1", text:"イベント一覧"
				expect(page).to have_no_selector "nav.pagination" 
			end

			context '開催開始日が過去のイベントは表示しない' do
				before do
					start_at = Time.zone.now.yesterday
					@event = FactoryBot.create(:event, start_at: start_at)

					visit root_path
				end

				it '過去のイベントは表示しない' do
					expect(page).to have_no_selector "a.list-group-item", text: @event.name
				end
			end

			context '開催日が将来のイベントは表示する' do
				before do
					start_at = Time.zone.now.tomorrow
					@event = FactoryBot.create(:event, start_at: start_at)

					visit root_path
				end

				it '将来のイベントは表示する' do
					expect(page).to have_selector "a.list-group-item", text: @event.name
				end
			end
		end

		context '11件以上表示でページネーションする' do
			before do
				for num in 1..11 do
					FactoryBot.create(:event)
				end
				visit root_path
			end

			it '11件表示でページネーションする' do
				expect(page).to have_selector "nav.pagination"
				expect(page).to have_link "次"
				expect(page).to have_link "最後"
				click_on "次"
				expect(page).to have_link "前"
				expect(page).to have_link "最初"
			end
		end
	end

	describe 'イベント詳細を表示' do
		before do
			@myself = FactoryBot.create(:user)
			sign_in_as(@myself)
			@event = FactoryBot.create(:event)
			visit event_path(@event)
		end

		it 'イベント詳細を表示' do
			expect(page).to have_selector "h1", text: @event.name
		end

		context '自身が作成したイベントは編集、削除ができる' do
			before do
				event = FactoryBot.create(:event, owner: @myself)
				visit event_path(event)
			end

			it '編集、削除ができる' do
				expect(page).to have_link 'イベントを編集する'
				expect(page).to have_link 'イベントを削除する'
				expect(page).to have_button '参加する'
			end
		end

		context '他人が作成したイベントは編集、削除ができない' do
			before do
				other = FactoryBot.create(:user)
				event = FactoryBot.create(:event, owner: other)
				visit event_path(event)
			end

			it '編集、削除ができない' do
				expect(page).to have_no_link 'イベントを編集する'
				expect(page).to have_no_link 'イベントを削除する'
				expect(page).to have_button '参加する'
			end
		end

		context '参加者がいる場合リストで表示' do
			before do
				@member = FactoryBot.create(:user)
				event = FactoryBot.create(:event, owner: @member)
				ticket = FactoryBot.create(:ticket, user: @member, event: event)
				visit event_path(event)
			end

			it '参加者リストで表示' do
				expect(page).to have_selector "li", text: @member.name
			end
		end

		context '参加者がいない場合参加者リストに表示しない' do
			before do
				event = FactoryBot.create(:event, owner: @myself)
				visit event_path(event)
			end

			it '参加者リストに表示しない' do
				within("ul.list-group") do
					expect(page).to have_no_selector "li"
				end
			end
		end

		context '他人が作成したイベントの場合' do
			before do
				other = FactoryBot.create(:user)
				event = FactoryBot.create(:event, owner: other)
				visit event_path(event)
			end

			it '参加するのボタンが表示される' do
				expect(page).to have_button '参加する'
			end

			context '参加するのボタンを押下した場合' do
				before do
					@comment = '参加する予定です'
					click_on '参加する'
					fill_in "ticket[comment]", with: @comment
					click_on '送信'
				end

				it '名前が参加リストに追加されキャンセルボタンが表示される' do
					within("ul.list-group") do
						expect(page).to have_selector "li.list-group-item", text: /@#{@myself.name}\s*#{@comment}/
					end
					expect(page).to have_link '参加をキャンセルする'
				end
			end
		end
	end

	describe 'イベントを作る' do
		before do
			sign_in_as(FactoryBot.create(:user))
			visit root_path
			click_on "イベントを作る"
		end

		it 'イベントを作る画面を表示' do
#			save_and_open_page
			expect(page).to have_selector "h1", text:"イベント作成"
		end

		context '通常通り作成した場合' do
			before do
				@event_name = 'TEST'
				fill_in '名前', with: @event_name
				fill_in '場所', with: 'place'
				select '12月', from: 'event_start_at_2i'
				select '30', from: 'event_start_at_3i'
				select '12月', from: 'event_end_at_2i'
				select '31', from: 'event_end_at_3i'
				fill_in '内容', with: 'content'
#				click_on '登録する'
			end

			it 'イベント詳細ページにリダイレクトする' do
				expect do
					click_on '登録する'
					sleep(1)
				end.to change(Event, :count).by(1)
				expect(page).to have_selector "h1", text: @event_name
			end
		end

		context '名前を空白で作成した場合' do
			before do
				fill_in '名前', with: ''
				fill_in '場所', with: 'place'
				select '12月', from: 'event_start_at_2i'
				select '30', from: 'event_start_at_3i'
				select '12月', from: 'event_end_at_2i'
				select '31', from: 'event_end_at_3i'
				fill_in '内容', with: 'content'
			end

			it 'イベントは作成されない' do
				expect do
					click_on '登録する'
					sleep(1)
				end.to change(Event, :count).by(0)
			end
		end
	end
end
