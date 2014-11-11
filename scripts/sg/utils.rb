class Utils
  def initialize
  end
  
  # what goes inside a generated .scss file
  def mixin(object) 
    mixin_name = split(object)
    "@mixin #{mixin_name} {}"
  end
  
  # what goes inside a generated styleguide file
  def yaml(object) 
    title = split(object)
    category = split(object, 1)
    ret = ''
    
    ret += '---' + "\n"
    ret += "layout: styleguide" + "\n"
    ret += "title: #{title.capitalize}" + "\n"
    ret += "category: #{category}" + "\n"
    ret += "scss: _#{title}.scss" + "\n"
    ret += '---' + "\n"
    
    ret
  end
  
  
  # convert the stleguide object to support SASS partials
  # ex: add: "atoms/test" #=> "atoms/_test"
  # ex: remove: "atoms/_test" #=> "atoms/test"
  def partial(object, operation = "add")
    split = object.split('/');
    change = split.last
    
    case operation
      when "add"
        object.sub change, "_#{change}"
      when "remove"
        object.sub change, change.sub('_', '')
    end
  end
  
  
  # split a styleguide object into mixin name and atomic folder name
  # ex: split('atoms/test') #=> test
  # ex: split ('atoms/test', 1) #=> atoms
  def split(object, index = 0)
    ret = object.split('/')
    
    ret[ret.length - index - 1]
  end
  
  # replace styleguide entry title or category
  # ex: rename_text_in_file('atoms/test1.html', 'Test', 'Test1') 
  def rename_text_in_file(file, text1, text2)
    oldf = File.read(file)
    newf = oldf.gsub(text1, text2)
    File.open(file, "w") {|f| f.puts newf}
  end
  
  # what files are ignored in '_includes'
  def ignore_includes
    ret = []
    ret << "_includes/jekyll/**/*"
    ret << ["_includes/styleguide", "_includes/styleguide/**/*"]
    ret << "_includes/*.html"
    ret << ["_includes/atoms/figure", "_includes/atoms/figure/*"]
    ret << ["_includes/atoms/sanitize.html", "_includes/atoms/imagetitle.html", "_includes/atoms/classname.html"]
    ret
  end
  
  # what files are ignored in 'assets'
  def ignore_assets
    ret = []
    ret << ["assets/styles/atoms/flex", "assets/styles/atoms/flex/*"]
    ret << ["assets/styles/styleguide", "assets/styles/styleguide/**/*"]
    ret << "assets/styles/**/*.liquid"
    ret << "assets/styles/**/*.css"
    ret << "assets/styles/*.scss"
    ret
  end
  
  # what files are ignored in 'styleguide'
  def ignore_sg
    ret = []
    ret << "styleguide/index.html"
    ret << "styleguide/**/index.html"
    ret
  end
  
  
  def stars(text)
    puts 
    puts
    (text.length + 4).times { putc "*" }
    puts
    puts "/ #{text} /"
    (text.length + 4).times { putc "*" }
    puts
  end
end