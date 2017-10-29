[
  './resource/validator',
  './resource/application'
].each {|resource| require_relative resource}

require 'date'

class Order < Application
  include Validator

  attr_accessor :book, :reader, :date

  def initialize(options={})
    self.validate(
      date_rule: options[:date] || Date.new
    )

    @book = options[:book]
    @reader = options[:reader]
    @date = options[:date]
  end
end