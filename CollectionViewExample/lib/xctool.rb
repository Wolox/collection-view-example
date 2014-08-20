class XCTool

  ACTIONS = %w(
    clean
    build
    build-tests
    test
    archive
    analyze
    install
  )

  XCTOOL_CMD = "xctool"

  class << self

    def to_action_method_name(action)
      if ACTIONS.include?(action)
        action.downcase.gsub("-", "_")
      end
    end

  end

  attr_reader :workspace, :scheme, :xctool_path

  def initialize(workspace, scheme, opts = {})
    @workspace = workspace
    @scheme = scheme
    @xctool_path = Pathname.new(opts[:xctool_path] || "")
    opts = {verbose: false, dry_run: false}.merge(opts)
    @verbose = opts[:verbose]
    @dry_run = opts[:dry_run]
  end

  def run(action, arguments = {}, options = {})
    if valid_action?(action)
      opts = default_base_options.merge(options)
      command = build_command(action, arguments, opts)
      execute(command)
    else
      raise "Invalid action #{action}"
    end
  end

  def dry_run?
    @dry_run
  end

  def verbose?
    @verbose
  end

  ACTIONS.each do |action|
    define_method(to_action_method_name(action)) do |*args|
      run(action, *args)
    end
  end

  private

    def build_command(action, arguments, options)
      options = to_options_string(options)
      arguments = to_options_string(arguments)
      "#{xctool} #{options} #{action} #{arguments}".strip
    end

    def execute(command)
      log("Executing command '#{command}'")
      system(command) unless dry_run?
    end

    def valid_action?(action)
      ACTIONS.include?(action)
    end

    def log(message)
      puts "#{self.class}: #{message}" if verbose?
    end

    def xctool
      xctool_path + XCTOOL_CMD
    end

    def default_base_options
      @default_base_options ||= { workspace: workspace, scheme: scheme }
    end

    def to_options_string(options = {})
      options.reduce("") do |options_string, (key, value)|
        if value
          options_string + " -#{key} #{value}"
        else
          options_string + " -#{key}"
        end
      end
    end

end