FactoryBot.define do
	factory :ticket do
		user
		event
		sequence(:comment) { |i| "コメント#{i}"} 
	end
end
