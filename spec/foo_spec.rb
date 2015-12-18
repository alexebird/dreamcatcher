require './spec/spec_helper'

describe Foo do
  describe '.new' do
    subject { Foo.new('hi') }
    it 'works' do
      expect(subject).to_not be nil
    end
  end

  describe '.bar?' do
    subject { Foo.new('hi') }

    it 'bars'

    it 'works' do
      expect(subject.bar?).to be true
    end

  end
end
