class AddBirthdayAndGenderToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :birthday, :date
    add_column :users, :gender, :integer
  end
end
