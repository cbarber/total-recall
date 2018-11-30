# frozen_string_literal: true

require './lib/total_recall/store'
require 'tempfile'

describe TotalRecall::Store do

  before do
    @trs = TotalRecall::Store.new
    @trs.add(previous_command: "git fetch --all", command: "git reset --hard")
  end

  describe "#predictions" do
    it "should be able to predict" do
      predictions = @trs.predictions(previous_command: "git fetch --all")
      expect(predictions.count).to eq(1)
    end
  end

  describe "#save" do
    it "should be able to save to a file" do
      temp_file = Tempfile.new('total_recall_store')
      @trs.save(filename: temp_file.path)
      expect(File.size(temp_file.path) > 0).to be_truthy
    end
  end
end