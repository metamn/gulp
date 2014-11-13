require_relative 'utils'

class Move
  def initialize(object1, object2, utils)
    @object1 = object1
    @object2 = object2
    @utils = utils

    @object1_partial = @utils.partial @object1
    @object2_partial = @utils.partial @object2

    move
  end

  def move
    puts "Moving #{@object1} to #{@object2}"

    create_folders

    html
    css
    sg

    rename

    remove_folders
  end

  def create_folders
    folder = @utils.split @object2, 1
    puts system("mkdir -p #{@utils.html}/#{folder}")
    puts system("mkdir -p #{@utils.sg}/#{folder}")
  end



  def html
    puts system("mv #{@utils.html}/#{@object1}#{@utils.ext} #{@utils.html}/#{@object2}#{@utils.ext}")
  end

  def css
    puts system("mv #{@utils.css}/#{@object1_partial}.scss #{@utils.css}/#{@object2_partial}.scss")
  end

  def sg
    puts system("mv #{@utils.sg}/#{@object1}#{@utils.ext} #{@utils.sg}/#{@object2}#{@utils.ext}")
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
    puts "Renaming 'mixin #{@name1}' to '#{@name2}' in #{@utils.css}/#{@object2_partial}.scss"
    @utils.rename_text_in_file "#{@utils.css}/#{@object2_partial}.scss", "#{@name1}", "#{@name2}"

    puts "Renaming 'title: #{@name1}' to '#{@name2}' in #{@utils.sg}/#{@object2}#{@utils.ext}"
    @utils.rename_text_in_file "#{@utils.sg}/#{@object2}#{@utils.ext}", "title: #{@name1.capitalize}", "title: #{@name2.capitalize}"

    puts "Renaming 'scss: #{@name1}' to '#{@name2}' in #{@utils.sg}/#{@object2}#{@utils.ext}"
    @utils.rename_text_in_file "#{@utils.sg}/#{@object2}#{@utils.ext}", "scss: #{@name1}", "scss: #{@name2}"
  end

  def rename_category
    puts "Renaming 'category: #{@category1}' to '#{@category2}' in #{@utils.sg}/#{@object2}#{@utils.ext}"
    @utils.rename_text_in_file "#{@utils.sg}/#{@object2}#{@utils.ext}", "category: #{@category1}", "category: #{@category2}"
  end


  def remove_folders
    folder = @utils.split @object1, 1
    puts system("rmdir -p #{@utils.html}/#{folder}")
    puts system("rmdir -p #{@utils.sg}/#{folder}")
  end
end
