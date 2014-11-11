require_relative 'utils'


class Remove
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
    
    remove
  end
  
  def remove
    puts "Removing #{@object} into:"
    puts " - #{@html}"
    puts " - #{@css}"
    puts " - #{@sg}"
    
    puts system("rm #{@html}/#{@object}#{@ext}")
    puts system("rm #{@css}/#{@object_partial}.scss")
    puts system("rm #{@sg}/#{@object}#{@ext}")
  end
end