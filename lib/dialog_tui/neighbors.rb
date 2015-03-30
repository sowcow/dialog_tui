module DialogTui

  class Neighbors
    def initialize array
      neighbors =\
        array.zip( array.rotate, array.rotate(-1) )

      keys_values =\
        neighbors.map { |entry, nexxt, prev|
          [
            entry,  # key
            { next: nexxt, prev: prev }  # value
          ]
        }

      @neighbors_of = Hash[keys_values]
    end

    def next from
      neighbors(from)[:next]
    end

    def prev from
      neighbors(from)[:prev]
    end

    private
    def neighbors entry
      @neighbors_of.fetch entry
    end
  end

end


# too much tests for one-liners class :)
# (that was written first btw)
# (upd: initialize is not a one-liner after refactoring,
#  but private method is simpler now and others
#  are more readable!)
#
# but I guess confidence and ability to rely on something
# costs it, and this simple one
# is a good point to start
#
# not that simple effect of tests
# is that I can write more complex code under them...
# hm...
# - so refactor wizely! and freely!


if __FILE__ == $0
  require 'maxitest/autorun'
  include DialogTui

  describe Neighbors do
    def subj
      Neighbors
    end

    describe 'constructor' do
      def call array
        subj.new array
      end

      it 'takes an array' do
        call [1,2,3]
      end
    end

    describe '#next' do
      def call array, entry
        subj.new(array).next entry
      end

      it 'takes an entry and returns next to it' do
        call([1,2,3], 1).must_equal 2
        call([1,2,3], 2).must_equal 3
      end

      it 'the next after the last is the first' do
        call([1,2,3], 3).must_equal 1
      end

      #it 'react in some way on unknown entry...'
      # not sure what behavior will be default
      # and not going to fix with tests that first
      # that came to my mind (Hash#fetch currently)
    end

    describe '#prev' do
      def call array, entry
        subj.new(array).prev entry
      end

      it 'is reverse of #next' do
        call([1,2,3], 1).must_equal 3
        call([1,2,3], 2).must_equal 1
        call([1,2,3], 3).must_equal 2
      end
    end

  end

end
