require 'filewatcher'

class Compile
  def initialize(file, utils)
    @root = Dir.pwd
    @destination = '_site/assets/styles'
    @extension = file + '.liquid'
    @file = file

    do_compile
  end


  # The .liquid file is compiled to .scss by Jekyll and put in _site/
  # We take this file and put in assets/styles
  # ex: /_site/assets/styles/atoms/test.liquid => /assets/styles/atoms/_test.scss

  def do_compile
    # Do watch
    puts "Watching #{@extension} files in #{@destination}"
    compile = true

    FileWatcher.new(["#{@destination}/*#{@extension}", "#{@destination}/**/#{@extension}"]).watch do |filename|
      puts "Compile: " + compile.to_s

      if compile
        # filename: ./_site/assets/styles/atoms/test.liquid
        puts "Updated " + filename

        # replace ./_site with absolute path
        absolute = filename.sub "./", "#{@root}/"
        #puts "Absolute " + absolute

        # replace .liquid with .scss
        scss = absolute.sub ".liquid", ".scss"

        # remove _site
        scss = scss.sub "_site/", ""
        #puts "Subs " + scss

        # rename "test" to "_test" since we are using SASS partials
        scss = scss.sub @file, "_#{@file}"

        # copy .liquid to .liquid.scss
        system("sudo cp -f #{absolute} #{scss}");

        # tell this script do not enter in an endless loop
        compile = false
      else
        compile = true
      end
    end
  end
end
