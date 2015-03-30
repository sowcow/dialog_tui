require_relative 'user_action/action'
require_relative 'user_action/read_char'

# if it failed - needs to be killed manually
# because ctrl+c is frozen
# okish?

module DialogTui
  module UserAction
    module_function

    def user_action &block
      UserActions.run &block
    end
    
    class UserActions
      def self.run &block
        new(&block).run
      end

      def initialize
        @actions = []
        yield self
      end

      DSL_METHODS = %i[

        ctrl_c

        enter
        esc

        up
        down
        left
        right
      ]

      DSL_METHODS.each { |name|
        define_method name do |&block|
          action = Action.new name, &block
          @actions << action
        end
      }

      def run
        loop {
          input = UserAction.read_char
          matched = @actions.select { |x| x.matches? input }

          if matched.any?
            matched.each &:call
            break
          else
            # just ignore and wait for next input
          end
        }
      end

    end
  end
end


if __FILE__ == $0
  require 'maxitest/autorun'

  describe DialogTui::UserAction do
    def subj
      DialogTui::UserAction
    end

    describe 'user_action method' do
      def this_method
        :user_action
      end

      it 'can be included or called directly' do

        subj = self.subj

        _My = Class.new do
          include subj
        end

        (_My.new.method(:non_existing) rescue :err).
          must_equal :err

        _My.new.method(this_method).
          wont_equal nil

        # actually not a deep testing of this one
        # full testing is possible TODO maybe
      end
    end

    it 'usage example' do

      puts " = press arrows to manually test it,\
           enter to finish,\
           esc if test is failed = ".squeeze(' ')

      finished = false

      begin
        subj.user_action { |key|
          key.up do    p :up  end
          key.down do  p :down  end
          key.left do  p :left  end
          key.right do p :right  end

          key.enter do
            finished = true
          end
          key.ctrl_c do
            exit 0  # xz
          end

          key.esc do
            'user decided the test is failed'.
              must_equal 'user said enter if test is ok'
            #raise 'user-driven test failed'
          end
        }
      end until finished

    end
  end

end
