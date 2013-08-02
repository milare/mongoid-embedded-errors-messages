require_relative '../test_helper'

describe MongoidEmbeddedErrorsMessages do
  describe 'mongoid document' do
    it 'should raise error if Mongoid::Document is not included' do
      lambda{
        class Fuu
          include MongoidEmbeddedErrorsMessages
        end
      }.must_raise(MongoidEmbeddedErrorsMessages::NotMongoidDocument)
    end
  end

  describe 'concerning' do
    it 'should has method embedded_errors_messages' do
      Foo.new.must_respond_to :embedded_errors_messages
    end
  end

  describe 'embedded_errors_messages' do
    before do
      @foo = Foo.new
      @bar = Bar.new
      @baz = Baz.new
      @qux = Qux.new
    end

    describe 'error just on parent' do
      it 'should have parent errors' do
        @foo.errors.add(:foo)
        @foo.embedded_errors_messages.must_equal ({foo: ['is invalid']})
      end
    end

    describe 'errors just on 1st level relation' do
      describe 'embeds_many relation' do
        before do
          @foo.bars << @bar
          @foo.bars << @bar
          @foo.bars << Bar.new
          @bar.errors.add(:bar)
        end

        it 'should have children errors' do
          @foo.embedded_errors_messages.must_equal ({bars: [{bar:['is invalid']}, {bar:['is invalid']}, nil]})
        end
      end

      describe 'embeds_one relation' do
        before do
          @foo.qux = @qux
          @qux.errors.add(:qux)
        end

        it 'should have child errors' do
          @foo.embedded_errors_messages.must_equal ({qux: {qux:['is invalid']}})
        end
      end

      describe 'embeds_one and embeds_many errors' do
        before do
          @foo.qux = @qux
          @foo.bars << @bar
          @foo.bars << Bar.new
          @foo.bars << @bar
          @qux.errors.add(:qux)
          @bar.errors.add(:bar)
        end

        it 'should have child errors' do
          @foo.embedded_errors_messages.must_equal ({bars: [{bar:['is invalid']}, nil, {bar:['is invalid']}], qux: {qux:['is invalid']}})
        end
      end
    end

    describe 'errors just on n-th level relation' do
      describe 'embeds_many relation' do
        before do
          @bar.quxs << @qux
          @bar.quxs << Qux.new
          @bar.quxs << @qux
          @foo.bars << @bar
          @qux.errors.add(:qux)
        end

        it 'should have children errors' do
          @foo.embedded_errors_messages.must_equal ({bars: [{quxs: [{qux: ["is invalid"]}, nil, {qux: ["is invalid"]}]}]})
        end
      end

      describe 'embeds_one relation' do
        before do
          @bar.baz = @baz
          @foo.bars << @bar
          @baz.errors.add(:baz)
        end

        it 'should have child errors' do
          @foo.embedded_errors_messages.must_equal ({bars: [{baz: {baz: ["is invalid"]}}]})
        end
      end

      describe 'embeds_one and embeds_many relations' do
        before do
          @bar.baz = @baz
          @foo.bars << @bar
          @baz.errors.add(:baz)

          @bar.quxs << @qux
          @bar.quxs << Qux.new
          @bar.quxs << @qux
          @foo.bars << @bars
          @qux.errors.add(:qux)
        end

        it 'should have child errors' do
          @foo.embedded_errors_messages.must_equal ({bars: [{baz: {baz: ["is invalid"]}, quxs: [{qux: ["is invalid"]}, nil, {qux: ["is invalid"]}] }] })
        end
      end
    end
  end
end


