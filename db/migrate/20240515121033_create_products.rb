class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :type
      t.float :protein
      t.float :fat
      t.float :carbohydrates
      t.float :calories

      t.timestamps
    end
  end
end
