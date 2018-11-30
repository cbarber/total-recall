module TotalRecall
  # Shell history enumerable
  class ShellHistory
    def initialize(shell = nil)
      @shell = shell || File.basename(ENV['SHELL'])
      @histfile = ENV['HISTFILE'] || histfile_path
    end

    def each(&block)
      history.each(&block)
    end

    protected def history
      Logging.logger.info("Fetching history for #{@shell}")
      case @shell
      when 'bash', 'dash', 'zsh'
        return numbered_history_from_histfile
      else
        return history_from_builtin
      end
    end

    protected def history_from_builtin
      Logging.logger.info('Fetching history from builtin')
      `#{@shell} -c history`.split(/\r?\n/)
    end

    protected def numbered_history_from_histfile
      Logging.logger.info("Fetching history from #{@histfile}")
      File.readlines(@histfile).map do |line|
        line.sub(/^\s+[0-9]+\s+/, '')
      end
    end

    protected def histfile_path
      case @shell
      when 'bash', 'dash'
        return "#{ENV['HOME']}/.bash_history"
      when 'zsh'
        "#{ENV['HOME']}/.zsh_history"
      end
    end
  end
end
