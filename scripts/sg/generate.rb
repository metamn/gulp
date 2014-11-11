require_relative 'utils'

class Generate
  def initialize(object)
    @object = object
    @root = Dir.pwd
    
    # for Jekyll
    #@html = @root + "/_includes"
    #@css = @root + "/assets/styles"
    #@sg = @root + "/styleguide"
    #@ext = ".html"
    
    # for Gulp
    @html = @root + "/components"
    @css = @root + "/components"
    @sg = @root + "/components/pages/styleguide"
    @ext = ".hbs"
    
    @utils = Utils.new
    @object_partial = @utils.partial @object
    
    generate
  end
  
  def generate
    puts "Generating #{@object} into:"
    puts " - #{@html}"
    puts " - #{@css}"
    puts " - #{@sg}"
    
    create_folders
    html
    css
    sg
  end
  
  def create_folders
    folder = @utils.split @object, 1
    puts system("mkdir -p #{@html}/#{folder}")
    puts system("mkdir -p #{@sg}/#{folder}")
  end
  
  def html
    puts system("echo '' > #{@html}/#{@object}#{@ext}")
  end
  
  def css
    puts system("echo '#{@utils.mixin(@object)}' > #{@css}/#{@object_partial}.scss")
  end
  
  def sg
    puts system("echo '#{@utils.yaml(@object)}' > #{@sg}/#{@object}#{@ext}")
  end
end