#!ruby
# frozen_string_literal: true

module TotalRecall
  class Store

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

    def save(filename:)
      TotalRecall::Store.save(store: self, filename: filename)
    end

    class << self
      def save(store:, filename:)
        File.open(filename, 'wb') { |f| f.write(Marshal.dump(store)) }
      end

      def load(filename:)
        Marshal.load(File.binread(filename))
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