require 'minitest/autorun'
require 'mongoid'
require File.expand_path('../../lib/mongoid-embedded-errors-messages.rb', __FILE__)

# Classes setup
class Foo
  include Mongoid::Document
  include MongoidEmbeddedErrorsMessages
  field :foo
  embeds_many :bars
  embeds_one :qux
end

class Bar
  include Mongoid::Document
  include MongoidEmbeddedErrorsMessages
  field :bar
  embeds_one :baz
  embeds_many :quxs
end

class Baz
  include Mongoid::Document
  include MongoidEmbeddedErrorsMessages
  field :baz
end

class Qux
  include Mongoid::Document
  include MongoidEmbeddedErrorsMessages
  field :qux
end

