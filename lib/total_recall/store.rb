#!ruby
# frozen_string_literal: true
require 'set'
require 'pp'

module TotalRecall
  class Store
    DEFAULT_FILENAME = '~/.total_recall.store'

    def initialize
      @commands = Hash.new
    end

    def add(previous_command:, command:)
      raise "Previous command and command must be defined!" unless previous_command && command
      existing_predictions = @commands[previous_command]
      if existing_predictions
        command_to_increment = existing_predictions.find { |c| c.string == command } || Command.new(command)
        command_to_increment.increment!
        existing_predictions << command_to_increment
      else
        new_entry = Command.new(command)
        new_entry.increment!
        @commands[previous_command] = Set.new
        @commands[previous_command] << new_entry
      end
    end

    def predictions(previous_command:, number_of_predictions: 3)
      existing_predictions = (@commands[previous_command] || []).sort_by(&:count).reverse
      existing_predictions.first(number_of_predictions)
    end

    def save(filename: DEFAULT_FILENAME)
      TotalRecall::Store.save(store: self, filename: filename)
    end

    def dump
      @commands.each_pair do |command, commands|
        puts "Command: #{command}"
        commands.sort_by(&:count).reverse.each do |cmd|
          puts "   #{cmd.string} -> #{cmd.count}"
        end
        puts
      end
    end

    class << self
      def save(store:, filename: DEFAULT_FILENAME)
        File.open(File.expand_path(filename), 'w+') { |f| f.write(Marshal.dump(store)) }
      end

      def load(filename: DEFAULT_FILENAME)
        if File.exist? File.expand_path(filename)
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
      raise "String can't be nil!" unless string
      @string = string
      @count = 0
    end

    def increment!
      @count += 1
      @last_touched = Time.now
    end
  end
end