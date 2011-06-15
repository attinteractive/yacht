After do
  Yacht::Loader.environment = nil
  Yacht::Loader.dir         = nil

  Yacht::Loader.instance_variable_set(:@config_file_names, nil)
  Yacht::Loader.instance_variable_set(:@classy_struct_instance, nil)

  Yacht.instance_variable_set(:@_loader, nil)
end