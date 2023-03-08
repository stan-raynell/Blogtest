class ChangeDataTypeForCommenter < ActiveRecord::Migration[7.0]
  def change
    change_table :comments do |t|
      t.change :commenter, :string
    end
  end
end