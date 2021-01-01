require 'site_prism'

module UlePage
  module SitePrismExtender
    include SitePrism::DSL
    include SitePrism

    # why define this method?
    # if we use the elements method directly, it will be conflicted with RSpec.Mather.BuiltIn.All.elements.
    # I have not found one good method to solve the confliction.
    def element_collection(collection_name, *find_args)
      build collection_name, *find_args do
        define_method collection_name.to_s do |*_runtime_args, &element_block|
          self.class.raise_if_block(self, collection_name.to_s, !element_block.nil?)
          page.all(*find_args)
        end
      end
    end

    # attr_accessor :attributes

    # can define fields based on the model class
    # usage:
    #   define_elements Brand
    def define_elements(model_class, props = [])
      attributes = model_class.new.attributes.keys

      props = attributes if props.empty?
      props.map!(&:to_s) unless props.empty?

      attributes.each do |attri|
        next unless props.include? attri

        selector = '#' + "#{class_name(model_class)}_#{attri}"

        element attri, selector
      end
    end

    # if you want to define the element as model1[modle2][name] whose id is "model1_model2_name"
    # useage
    #   define Brand User
    #   define Brand, User, [:description]
    def define_sub_elements(model_class, submodel_class, props = [])
      attributes = submodel_class.new.attributes.keys

      props = attributes if props.empty?
      props.map!(&:to_s) unless props.empty?

      attributes.each do |attri|
        next unless props.include?(attri)

        selector = '#' + "#{class_name(model_class)}_#{class_name(submodel_class)}_attributes_#{attri}"

        element attri, selector
      end
    end

    def class_name(my_class)
      my_class.name.underscore.downcase
    end

    # instead of the rails traditional form
    # in js mode, there is no prefix before the element name
    def define_elements_js(model_class, excluded_props = [])
      attributes = model_class.new.attributes.keys

      attributes.each do |attri|
        next if excluded_props.include? attri

        selector = '#' + attri
        # self.class.send "element", attri.to_sym, selector
        element attri, selector
      end
    end
  end
end
