class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :resource_server
      t.string :authorization_server
      t.string :client_id
      t.string :registration_client_uri
      t.text :registration_access_token
      t.string :logo

      t.timestamps
    end
  end
end
