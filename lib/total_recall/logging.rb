require 'logger'

module TotalRecall
  # Shared logging singleton
  module Logging
    def logger
      Logging.logger
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
