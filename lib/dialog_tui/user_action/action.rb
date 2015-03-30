module DialogTui
  module UserAction

    class Action
      def initialize name, mapping=CHARS, &block
        @matches = mapping.fetch name.to_sym
        @block = block
      end

      attr_reader :matches
      private     :matches

      def match? input
        matches == input
      end

      alias matches? match?

      def call
        @block.call
      end

      # any other mapping can be passed into constructor!
      # sounds odd to pass it here,
      # builder is a better idea,
      # anyway strange class + builder here...
      #
      CHARS = {
        ctrl_c: "\u0003",
        space:  ' ',

        esc:     "\e",
        escape:  "\e",

        enter:  "\r",
        return: "\r",

        up:    "\e[A",
        down:  "\e[B",
        right: "\e[C",
        left:  "\e[D",
      }
    end

  end
end


if __FILE__ == $0
  require 'maxitest/autorun'

  describe DialogTui::UserAction::Action do
    def subj
      DialogTui::UserAction::Action
    end

    describe 'constructor' do
      def call *a, &b
        subj.new *a, &b
      end

      # FIXME user-actions sounds more abstract
      #       but it is coupled to keys...
      #
      it 'takes a key name and action block' do
        call :enter do  puts :hey  end
      end

      it 'optionally takes a mapping of actions' do
        mapping = {
          :any => '*'
        }
        call(:any, mapping).match?('*').must_equal true
        # odd test?
        # even if to ignore it uses other methods
        # (not certain about that yet)
      end
    end


    describe '#matches?' do

      it 'is aliased with #match?' do
        action = subj.new :enter do end

        action.method(:matches?).must_equal\
          action.method(:match?)
      end

      it 'checks if a given key is handled by the action' do
        action = subj.new :enter do end
        action.matches?("\r").must_equal true
        action.matches?(" ").must_equal false
        action.matches?("\n").must_equal false
        # the last one looks non-intuitive
      end

    end


    describe '#call' do
      it 'calls an action block' do
        called = false
        action = subj.new :enter do
          called = true
        end
        called.must_equal false
        action.call
        called.must_equal true
      end
    end

  end
end
