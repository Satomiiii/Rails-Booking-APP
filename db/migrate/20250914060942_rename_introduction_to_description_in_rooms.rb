class RenameIntroductionToDescriptionInRooms < ActiveRecord::Migration[6.1]
  def change
    rename_column :rooms, :introduction, :description
  end
end
