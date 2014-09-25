class CreateAhoyEvents < ActiveRecord::Migration
  def change
    create_table :ahoy_events, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :visit_id

      # user
      t.integer :user_id
      # add t.string :user_type if polymorphic

      t.string :name
<<<<<<< HEAD
      t.column :properties,:json
=======
      t.column :properties, :json
>>>>>>> a11b3785888c7d6f1718c47ca76eb8b25aebddba
      t.timestamp :time
    end

    add_index :ahoy_events, [:visit_id]
    add_index :ahoy_events, [:user_id]
    add_index :ahoy_events, [:time]
    add_foreign_key :ahoy_events, :users, name: :ahoy_events_user_id_fk, column: :user_id
  end
end
