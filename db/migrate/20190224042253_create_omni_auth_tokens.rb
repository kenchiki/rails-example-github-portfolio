class CreateOmniAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :omni_auth_tokens do |t|
      t.string :token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
