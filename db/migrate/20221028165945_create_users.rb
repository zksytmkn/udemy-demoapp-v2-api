class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # 追加
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :activated, null: false, default: false
      t.boolean :admin, null: false, default: false
      # ここまで
      t.timestamps
    end
  end
end
