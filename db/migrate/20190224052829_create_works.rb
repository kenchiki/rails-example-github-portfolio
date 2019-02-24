class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.string :name
      t.string :image
      t.text :description
      t.integer :repository_id, null: false
      t.string :language
      t.string :svn_url, null: false
      t.integer :stargazers, null: false
      t.integer :forks, null: false
      t.integer :watchers, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :works, :repository_id, unique: true

  end
end
