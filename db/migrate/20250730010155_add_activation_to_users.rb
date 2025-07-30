class AddActivationToUsers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:users, :activation_digest)
      add_column :users, :activation_digest, :string
    end

    unless column_exists?(:users, :activated)
      add_column :users, :activated, :boolean, default: false
    end

    unless column_exists?(:users, :activated_at)
      add_column :users, :activated_at, :datetime
    end
  end
end
