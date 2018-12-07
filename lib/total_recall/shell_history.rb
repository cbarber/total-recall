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
      Logging.logger.debug("Fetching history for #{@shell}")
      case @shell
      when 'bash', 'dash', 'zsh'
        return numbered_history_from_histfile
      else
        return history_from_builtin
      end
    end

    protected def history_from_builtin
      Logging.logger.debug('Fetching history from builtin')
      `#{@shell} -c history`.split(/\r?\n/)
    end

    protected def numbered_history_from_histfile
      Logging.logger.debug("Fetching history from #{@histfile}")
      File.readlines(@histfile, encoding: 'UTF-8').map do |line|
        line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        if @shell != 'zsh'
          line.sub(/^\s+[0-9]+\s+/, '').chomp
        else
          line.sub(/^:\s+[0-9:]+;/, '').chomp
        end
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
