require_relative 'find'
require_relative 'utils'

class Unused
  def initialize(utils)
    @root = Dir.pwd
    @dirs = @root + '/assets/styles'
    @utils = utils

    unused
  end

  def unused
    puts "Checking for unused mixins"

    mixins = get_all_mixins
    #puts mixins
    mixins.each do |mixin|
      find = Find.new mixin
      @utils.stars "#{mixin} not found" unless find.found
    end
  end

  def get_all_mixins
    ret = []

    Dir.glob(File.join(@dirs, "**", "*.scss")).each do |f|
      mixin = File.readlines(f).select { |line| line =~ /@mixin / }
      ret << sanitize(mixin.first) unless mixin.empty?
      #puts mixin
    end

    ret
  end


  def sanitize(mixin)
    split1 = mixin.split "@mixin "
    split1 = split1.last

    # @mixin button {
    split2 = split1.split " " if split1.include? " "

    # @mixin button($param ....
    split2 = split1.split "(" if split1.include? "("

    split2.first
  end
end
