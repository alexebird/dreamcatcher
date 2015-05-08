class Foo

  attr_accessor :bar

  def initialize(val)
    @var = val
  end

  def bar?
    return bar == true
  end

  def bar!
    bar = nil
  end
end
