#!ruby
# frozen_string_literal: true
require 'set'

module TotalRecall
  class Store
    DEFAULT_FILENAME = '~/.total_recall.store'

    def initialize
      @commands = Hash.new(Set.new)
    end

    def add(previous_command:, command:)
      existing_predictions = @commands[previous_command]
      command_to_increment = existing_predictions.find { |c| c.string == command }
      if command_to_increment
        command_to_increment.increment!
      else
        new_entry = Command.new(command)
        new_entry.increment!
        @commands[previous_command] << new_entry
      end
    end

    def predictions(previous_command:, number_of_predictions: 3)
      existing_predictions = (@commands[previous_command]).sort_by { |c| c.count }
      existing_predictions.first(number_of_predictions)
    end

    def save(filename: DEFAULT_FILENAME)
      TotalRecall::Store.save(store: self, filename: filename)
    end

    class << self
      def save(store:, filename: DEFAULT_FILENAME)
        File.open(File.expand_path(filename), 'w+') { |f| f.write(Marshal.dump(store)) }
      end

      def load(filename: DEFAULT_FILENAME)
        if File.exist? filename
          Marshal.load(File.binread(File.expand_path(filename)))
        else
          TotalRecall::Store.new
        end
      end
    end
  end

  class Command
    attr_accessor :string, :count, :last_touched

    def initialize(string)
      @string = string
      @count = 0
    end

    def increment!
      @count += 1
      @last_touched = Time.now
    end
  end
end