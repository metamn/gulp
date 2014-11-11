require_relative 'utils'

class Move
  def initialize(object1, object2)
    @object1 = object1
    @object2 = object2
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
    @object1_partial = @utils.partial @object1
    @object2_partial = @utils.partial @object2
    
    move
  end
  
  def move
    puts "Moving #{@object1} to #{@object2}"
    
    html
    css
    sg
    
    rename
  end
  
  def html
    puts system("mv #{@html}/#{@object1}.html #{@html}/#{@object2}#{@ext}")
  end
  
  def css
    puts system("mv #{@css}/#{@object1_partial}.scss #{@css}/#{@object2_partial}.scss")
  end
  
  def sg
    puts system("mv #{@sg}/#{@object1}.html #{@sg}/#{@object2}#{@ext}")
  end
  
  
  
  def rename
    @name1 = @utils.split(@object1)
    @name2 = @utils.split(@object2)
    rename_names if (@name1 != @name2)
    
    @category1 = @utils.split(@object1, 1)
    @category2 = @utils.split(@object2, 1)
    rename_category if (@category1 != @category2) 
  end
  
  def rename_names
    puts "Renaming 'mixin #{@name1}' to '#{@name2}' in #{@css}/#{@object2_partial}.scss"
    @utils.rename_text_in_file "#{@css}/#{@object2_partial}.scss", "#{@name1}", "#{@name2}"
    
    puts "Renaming 'title: #{@name1}' to '#{@name2}' in #{@sg}/#{@object2}#{@ext}"
    @utils.rename_text_in_file "#{@sg}/#{@object2}#{@ext}", "title: #{@name1.capitalize}", "title: #{@name2.capitalize}"
    
    puts "Renaming 'scss: #{@name1}' to '#{@name2}' in #{@sg}/#{@object2}#{@ext}"
    @utils.rename_text_in_file "#{@sg}/#{@object2}#{@ext}", "scss: #{@name1}", "scss: #{@name2}"
  end
  
  def rename_category
    puts "Renaming 'category: #{@category1}' to '#{@category2}' in #{@sg}/#{@object2}#{@ext}"
    @utils.rename_text_in_file "#{@sg}/#{@object2}#{@ext}", "category: #{@category1}", "category: #{@category2}"
  end
end