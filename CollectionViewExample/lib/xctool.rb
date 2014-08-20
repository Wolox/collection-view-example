class XCTool

  attr_reader :workspace, :scheme, :xctool_path

  def initialize(workspace, scheme, xctool_path = nil)
    @workspace = workspace
    @scheme = scheme
    @xctool_path = xctool_path
  end

  def run(action, arguments = {}, options = {})
    opts = default_base_options.merge(options)
    cmd = "#{xctool} #{build_string(opts)} #{action} #{build_string(arguments)}".strip
    log("Running command '#{cmd}'")
    system(cmd) unless ENV['DRY']
  end

  def method_missing(method, *args, &block)
    send(:run, method, *args)
  end

  private

    def log(message)
      puts message if ENV['VERBOSE']
    end

    def xctool
      if xctool_path
        "#{xctool_path}/xctool"
      else
        "xctool"
      end
    end

    def default_base_options
      @default_base_options ||= { workspace: workspace, scheme: scheme }
    end

    def build_string(options = {})
      options.reduce("") do |options_string, (key, value)|
        if value
          options_string + " -#{key} #{value}"
        else
          options_string + " -#{key}"
        end
      end
    end

end