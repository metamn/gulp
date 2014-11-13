require_relative 'utils'

class Generate
  def initialize(object, utils)
    @object = object
    @utils = utils

    @object_partial = @utils.partial @object

    generate
  end

  def generate
    puts "Generating #{@object} into:"
    puts " - #{@utils.html}"
    puts " - #{@utils.css}"
    puts " - #{@utils.sg}"

    create_folders
    html
    css
    sg
  end

  def create_folders
    folder = @utils.split @object, 1
    puts system("mkdir -p #{@utils.html}/#{folder}")
    puts system("mkdir -p #{@utils.sg}/#{folder}")
  end

  def html
    puts system("echo '' > #{@utils.html}/#{@object}#{@utils.ext}")
  end

  def css
    puts system("echo '#{@utils.mixin(@object)}' > #{@utils.css}/#{@object_partial}.scss")
  end

  def sg
    puts system("echo '#{@utils.yaml(@object)}' > #{@utils.sg}/#{@object}#{@utils.ext}")
  end
end
