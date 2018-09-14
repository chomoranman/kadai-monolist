class CreateOwnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :ownerships do |t|
      t.string :type
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
      #↓user_id, item_id, type(Want, Have)のペアで重複するものが保存されないようにする設定#
      t.index [:user_id, :item_id, :type], unique: true
    end
  end
end
