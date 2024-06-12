class AddGoalAndMobilityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :goal, :string
    add_column :users, :mobility, :integer
    add_column :users, :goal_value, :integer
  end
end
