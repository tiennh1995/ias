class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :avatar
      t.string :display_id

      t.timestamps
    end
  end
end
