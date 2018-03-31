require 'Open3'

class SystemClient
  CliResult = Struct.new :stdout, :stderr, :status do
    # delegate :success?, to: :status

    def success? 
      @status
    end

    def failure?
      !success?
    end
  end

  def self.run(command, args:)
    args = args.map(&:to_s)
    opts = {}
    CliResult.new(*Open3.capture3(command, *args, **opts))
  end
end