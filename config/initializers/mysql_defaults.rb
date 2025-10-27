# config/initializers/mysql_defaults.rb
ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES[:string] = { name: "varchar", limit: 191 }
end