module Pageflow
  # Options to be defined in the pageflow initializer of the main app.
  class Configuration
    # Default options for paperclip attachments which are supposed to
    # use filesystem storage.
    attr_accessor :paperclip_filesystem_default_options

    # Default options for paperclip attachments which are supposed to use
    # s3 storage.
    attr_accessor :paperclip_s3_default_options

    # String to interpolate into paths of files generated by paperclip
    # preprocessors. This allows to refresh cdn caches after
    # reprocessing attachments.
    attr_accessor :paperclip_attachments_version

    # Path to the location in the filesystem where attachments shall
    # be stored. The value of this option is available via the
    # pageflow_filesystem_root paperclip interpolation.
    attr_accessor :paperclip_filesystem_root

    # Refer to the pageflow initializer template for a list of
    # supported options.
    attr_accessor :zencoder_options

    # A constraint used by the pageflow engine to restrict access to
    # the editor related HTTP end points. This can be used to ensure
    # the editor is only accessable via a certain host when different
    # CNAMES are used to access the public end points of pageflow.
    attr_accessor :editor_route_constraint

    # Subscribe to hooks in order to be notified of events. Any object
    # with a call method can be a subscriber
    #
    # Example:
    #
    #     config.hooks.subscribe(:submit_file, -> { do_something })
    #
    attr_reader :hooks

    # Limit the use of certain resources. Any object implementing the
    # interface of Pageflow::Quota is allowed.
    attr_accessor :quota

    def initialize
      @paperclip_filesystem_default_options = {}
      @paperclip_s3_default_options = {}

      @zencoder_options = {}

      @hooks = Hooks.new
      @quota = Quota::Unlimited.new
    end

    def on(*args)
      hooks.on(*args)
    end

    # Make a page type available for use in the system.
    def register_page_type(page_type)
      page_types << page_type

      @page_types_by_name ||= {}
      @page_types_by_name[page_type.name] = page_type
    end

    def lookup_page_type(name)
      @page_types_by_name.fetch(name)
    end

    def page_types
      @page_types ||= []
    end

    def page_type_names
      page_types.map(&:name)
    end
  end
end
