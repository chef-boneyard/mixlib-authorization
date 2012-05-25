require File.expand_path('../settings', __FILE__)

Sequel.migration do
  change do

    create_table(:node_status) do
      String(:org_id, :null => false, :fixed => true, :size => 32)
      String(:node_name, :null => false)
      Integer(:status, :null => false)

      String(:last_updated_by, :null => false, :fixed => true, :size => 32)
      DateTime(:created_at, :null => false)
      DateTime(:updated_at, :null => false)
      primary_key([:org_id, :node_name])
      unique([:org_id, :node_name]) # only one node with a given name in an org
    end
  end
end
