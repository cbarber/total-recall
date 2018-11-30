require 'bundler/setup'
require 'optimist'
require './lib/quaid_store'

SUB_COMMANDS = %w(add predict)
global_opts = Optimist::options do
  banner "predictive shell history"
  stop_on SUB_COMMANDS
end

cmd = ARGV.shift # get the subcommand
cmd_opts = case cmd
           when "add" # parse delete options
             Optimist::options do
               opt :'command', "Current shell command"
               opt :'previous-command', "Previous shell command"
             end
           when "predict"  # parse copy options
             Optimist::options do
               opt :number, "number of predictions"
               opt :'previous-command', "last command that you ran"
             end
           else
             Optimist::die "unknown subcommand! Please run either quaid add or quaid predict"
           end

# puts "Global options: #{global_opts.inspect}"
# puts "Subcommand: #{cmd.inspect}"
# puts "Subcommand options: #{cmd_opts.inspect}"
# puts "Remaining arguments: #{ARGV.inspect}"

quaid_store_file = '~/.total_recall.store'
@trs             = File.exist?(quaid_store_file) ? Quaid::Store.load(filename: quaid_store_file) : Quaid::Store.new

case cmd
when "add"
  @trs.add(command: cmd_opts[:command], previous_command: cmd_opts[:'previous-command'])
  @trs.save(filename: quaid_store_file)
when "predict"
  @trs.predict(command: cmd_opts[:command])
end