require_relative 'dialog_tui/neighbors'
require_relative 'dialog_tui/user_action'


module DialogTui
  module_function  # include or call explicitly


  # preferred public interface
  #
  # usage example:
  #
  # dialog { |an|
  #
  #   an.option '1. first' do
  #     puts 'hey, user just chosen this one!'
  #   end
  #
  #   an.option '2. second' do
  #   end
  #
  #   an.option 'you got it' do
  #   end
  # }
  #
  def dialog &block
    Dialog.run &block
  end


  class Dialog
    include UserAction

    def self.run &block
      new(&block).run
    end


    def initialize &block
      @options = []

      if block.arity == 0
        instance_eval &block
      else
        block.call self
      end

      raise unless @options.count > 0
      # options list is assumed to be fixed now

      @current = @options.first
      @neighbors = Neighbors.new @options
    end

    def run
      begin
        # print_usage  #...
        print_options  # would be nice to have a printer...

        done = false
        
        user_action { |key|

          key.up do
            @current = prev
          end

          key.down do
            @current = nexxt
          end

          #key.ctrl_c do  exit 0  end
          #key.esc do     exit 0  end

          key.enter do
            done = true
          end
        }
      end until done

      @current.call
    end

    def chosen? option
      @current == option  # so current or chosen?)
    end

    private
    def option text, &reaction
      option = Option.new self, text, &reaction  # order?
      @options.push option
    end

    def print_options
      puts '-'*10
      @options.each &:print
      puts '-'*10
    end

    def prev
      @neighbors.prev @current
    end

    def nexxt
      @neighbors.next @current
    end
  end


  # NOTE: not sure about perfomance implications
  # of that chain of &block passing instead of
  # just using variable w/o `&`
  # but & looks very explicit and is not as annoying
  # as additional parameter

  class Option
    def initialize dialog, text, &reaction
      @dialog = dialog
      @text = text.to_s
      @reaction = reaction
    end

    def call
      @reaction.call
    end

    def print printer=nil  # just to be here for future
                                          # refactoring
      if chosen?
        puts '=> ' + @text
      else
        puts '   ' + @text
      end
    end

    def chosen?
      @dialog.chosen? self
    end
  end


end


if __FILE__ == $0

  class My
    include DialogTui
  
    def act
  
      dialog {
  
        option '1. hey' do
          puts 'you choose the first one!'
        end
  
        option '2. hi!' do
          puts 'you choose the second one!'
        end
  
        option '3. bye' do
          puts '*waving*'
        end
      }.
      tap { |result|
        raise unless result.nil?
        # because it works for effect, not for return value
      }
  
    end
  end
  
  puts 'manual testing here - use arrows and enter'
  puts 'no way to fail it - just look at behavior'
  3.times { My.new.act }
end
