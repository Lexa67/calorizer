class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :age, :integer
    add_column :users, :weight, :integer
    add_column :users, :gender, :string
    add_column :users, :height, :integer
  end
end
