[
  './resource/application'
].each {|resource| require_relative resource}

class Book < Application
  attr_accessor :title, :author

  def initialize(options={})
    @title = options[:title]
    @author = options[:author]
  end
end