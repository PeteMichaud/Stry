# Automatically fetches appropriates objects for controllers
# Examples:

# portfolio/1 => @portfolio.id == 1
# portfolio/new => @portfolio.new_record? == true
# portfolio/1/entry/3 => @portfolio.id == 1, @portfolio_entry.id == 3

module Warwick

  # call the before_filter to make everything work
  def self.included(base)
    base.before_filter :load_resource
  end

  # Used when determining if we want a new object, ie Object.new
  # The default is to create a new object only when the action is "new",
  # but this can be expanded to include any action
  @@new_actions = %w(new)

  def self.new_actions
    @@new_actions
  end

  # Use at the top of controller class, eg:
  # load_new_on %w(new my_custom_new_action)
  def self.load_new_on=(value)
    @@new_actions = value
  end

  #/new actions

  # Used when determining if we want a collection of objects, ie Object.all
  # The default is to create an object collection only when the action is "index",
  # but this can be expanded to include any action
  @@collection_actions = %w(index)

  def self.collection_actions
    @@collection_actions
  end

  # Use at the top of controller class, eg:
  # load_collection_on %w(index my_custom_collection_action)
  def self.load_collection_on=(value)
    @@collection_actions = value
  end

  #/collection actions

  #autoloads controller @object by default
  @@autoload_resource = true

  #call this at the top of your controller to disable @object autoload
  def self.load_resource_manually
    @@autoload_resource = false
  end

  protected

  #automatically loads controller @object or @objects collection, loading a Decorator if available
  def load_resource

    return unless @@autoload_resource

    resource_class, id_symbol, variable_name = get_resource_data(controller_name.singularize)
    create_class_variable(id_symbol, resource_class, variable_name) if resource_class

    parent_ids.each do |parent_id_symbol|
      resource_class, _, variable_name = get_resource_data(parent_id_symbol[0...-3])
      create_class_variable(parent_id_symbol, resource_class, variable_name) if resource_class
    end

  end

  private


  # return param keys that are for parent objects
  def parent_ids
    params.keys.select { |k| k =~ /\_id$/ }
  end


  def get_resource_data base_name
    variable_name = "@#{base_name}"
    id_symbol = load_instance?(variable_name)
    begin
      resource_class = get_resource_class(base_name.classify)
    rescue NameError => ex
      #this isn't a controller that we can get a resource for, so do nothing
      return false
    end

    return resource_class, id_symbol, variable_name
  end

  # id_symbol: something like :id or :object_id (or it might be false)
  # class constant for the type of object we want to build
  # name of the class variable to build
  def create_class_variable(id_symbol, resource_class, variable_name)
    #if there is an id that we can use to get an object, use it
    variable_value = if id_symbol
                       resource_class.find(params[id_symbol])
                       #other check to see if we should build a new object
                     elsif build_instance?
                       resource_class.respond_to?(:delegate_all) ? resource_class.source_class.new : resource_class.new
                       #or get a collection of a type of object
                     elsif load_collection?
                       variable_name = variable_name.pluralize
                       resource_class.all
                     end

    instance_variable_set(variable_name, variable_value)
  end

  #if the decorator is available, use it
  def get_resource_class name
    begin
      return "#{name}Decorator".constantize
    rescue
      return name.constantize
    end
  end

  #looks for either an :id param or :object_name_id param
  def load_instance? variable_name
    if params.has_key?(:id)
      return :id
    elsif params.has_key?(:"#{variable_name.underscore}_id")
      return :"#{variable_name.underscore}_id"
    end
    false
  end

  def build_instance?
    @@new_actions.include? params[:action]
  end

  def load_collection?
    @@collection_actions.include? params[:action]
  end

end