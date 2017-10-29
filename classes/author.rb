[
  './resource/application'
].each {|resource| require_relative resource}

class Author < Application
  attr_accessor :name, :biography

  def initialize(options={})
    @name = options[:name]
    @biography = options[:biography] || []
  end
end