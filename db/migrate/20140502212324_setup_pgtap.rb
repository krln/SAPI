class SetupPgtap < ActiveRecord::Migration
  def self.up
    if Rails.env.test?
      execute "CREATE EXTENSION IF NOT EXISTS pgtap"
    end
  end

  def self.down
    if Rails.env.test?
      execute "DROP EXTENSION pgtap"
    end
  end
end
