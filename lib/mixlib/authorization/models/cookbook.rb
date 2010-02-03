#
# Author:: Christopher Brown <cb@opscode.com>
#
# Copyright 2009, Opscode, Inc.
#
# All rights reserved - do not redistribute
#

module Mixlib
  module Authorization
    module Models
      class Cookbook < CouchRest::ExtendedDocument
        include CouchRest::Validation
        include Mixlib::Authorization::AuthHelper
        include Mixlib::Authorization::JoinHelper
        include Mixlib::Authorization::ContainerHelper
        
        use_database Mixlib::Authorization::Config.default_database
        
        view_by :display_name
        view_by :latest_revision,
        :map =>
          "function(doc) { emit(doc.display_name, doc) }",
        :reduce =>
          "function(key, values) { return values.sort(function(a,b){return b.revision-a.revision})[0] }"
        
        property :display_name
        property :revision
        property :orgname
        
        validates_present :display_name, :revision, :orgname
        
        auto_validate!

        inherit_acl
        
        create_callback :after, :save_inherited_acl, :create_join
        update_callback :after, :update_join
        destroy_callback :before, :delete_join
        
        join_type Mixlib::Authorization::Models::JoinTypes::Object 
        join_properties :requester_id
        
        def for_json
          self.properties.inject({ }) do |result, prop|
            pname = prop.name.to_sym
            #BUGBUG - I hate stripping properties like this.  We should do it differently [cb]      
            result[pname] = self.send(pname) unless pname == :requester_id
            result
          end
        end
        
      end
    end
  end
end
