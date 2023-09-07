class AddContentToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :content, :string
  end
end
