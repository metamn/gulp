require_relative 'sg/compile'
require_relative 'sg/generate'
require_relative 'sg/remove'
require_relative 'sg/move'
require_relative 'sg/check'
require_relative 'sg/find'
require_relative 'sg/unused'

class Styleguide
  def initialize
    @command = ARGV[0].to_s
    @param1 = ARGV[1].to_s
    @param2 = ARGV[2].to_s
    
    usage if (@command.empty? or @param1.empty?) and !(["check", "unused"].include? @command)
    run_command
  end
  
  def run_command
    case @command
      when "c"
        Compile.new @param1
      when "g"
        Generate.new @param1
      when "rm"
        Remove.new @param1
      when "mv"
        usage if @param2.empty?
        Move.new @param1, @param2
      when "check"
        Check.new
      when "find"
        Find.new @param1
      when "unused"
        Unused.new
      else
        usage
    end
  end
  
  def usage
    puts "Usage: sg command [object1] [object2]"
    puts "Example:"
    puts " - sg c fonts #=> compile fonts.liquid"
    puts " - sg g atoms/player/header #=> generates the 'header' styleguide objects"
    puts " - sg rm atoms/player/header #=> removes the 'header' styleguide objects"
    puts " - sg mv atoms/player/header molecules/player/header #=> moves the header styleguide objects"
    puts " - sg check #=> checks the consistency of the styleguide with atomic components"
    puts " - sg find button #=> checks if the 'button' mixin is used in the SCSS files"
    abort
  end
end

sg = Styleguide.new