[
  './resource/validator',
  './resource/application'
].each {|resource| require_relative resource}

class Reader < Application
  include Validator

  attr_accessor :name, :email, :city, :street, :house

  def initialize(options={})
    self.validate(
      email_rule: options[:email] || 'default@mail.com'
    )

    @name = options[:name]
    @email = options[:email]
    @city = options[:city]
    @street = options[:street]
    @house = options[:house]
  end
end