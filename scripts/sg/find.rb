class Find
  def initialize(mixin)
    @root = Dir.pwd
    @dirs = @root + '/assets/styles'
    @mixin = mixin
    @found = find
  end
  
  def find
    #puts "Looking for #{@mixin} in #{@dirs}"
    system('grep -r -o -i "' + "@include #{@mixin}" + '" ' + "#{@dirs}" + '/*')
  end
  
  def found
    @found
  end
end