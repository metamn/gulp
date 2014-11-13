require_relative 'utils'

class Check
  def initialize(utils)
    @utils = utils
    @includes = files('_includes', @utils.ignore_includes)
    @assets = files('assets/styles', @utils.ignore_assets)
    @sg = files('styleguide', @utils.ignore_sg)

    check
  end



  def check
    prettyprint "assets vs styleguide"
    puts compare(@assets, @sg, 'assets/styles', 'styleguide')

    prettyprint "styleguide vs assets"
    puts compare(@sg, @assets, 'styleguide', 'assets/styles')

    prettyprint "_includes vs assets"
    puts compare(@includes, @assets, '_includes', 'assets/styles')

    prettyprint "_includes vs styleguide"
    puts compare(@includes, @sg, '_includes', 'styleguide')

    puts
  end


  # all files from a folder minus the excluded ones
  def files(folder, ignore)
    all = Dir.glob(folder + "/**/*")
    ignore.each {|i| all = all - Dir.glob(i)}

    all
  end

  # compare two sytleguide entities
  # ex: files from 'assets' to files from 'styleguide'
  def compare(array1, array2, prefix1, prefix2)
    a1 = array1.map {|a| tidy(a, prefix1) }
    a2 = array2.map {|a| tidy(a, prefix2) }
    a1 - a2
  end

  # tidy up a filename for comparision
  # ex: _includes/atoms/colors.html #=> atoms/colors
  # ex: assets/styles/atoms/_colors.scss #=> atoms/colors
  def tidy(object, prefix)
    object.gsub!(prefix, '')
    object.chomp!(".html")

    object = @utils.partial(object, "remove") if object.include?('.scss')
    object.chomp!(".scss")

    object
  end

  def prettyprint(text)
    @utils.stars text
    puts "Missing from #{text.split(' vs ').last}:"
    puts
  end
end
