module TotalRecall
  # Shell history enumerable
  class ShellHistory
    def initialize
      @shell = ENV['SHELL']
    end

    def each(&block)
      history.each(&block)
    end

    protected def history
      Logging.logger.info("Fetching history for #{@shell}")
      `$SHELL -c history`.split(/\r?\n/)
    end
  end
end
