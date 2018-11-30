module TotalRecall
  class Importer

    def initialize(store)
      @store = store
    end

    def import
      previous_command = nil
      history = TotalRecall::ShellHistory.new
      history.each do |line|
        if previous_command
          Logging.logger.debug("Adding \"#{previous_command}\" -> \"#{line}\"")
          @store.add(previous_command: previous_command, command: line)
        end
        previous_command = line
      end
    end
  end
end