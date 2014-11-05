# Require any additional compass plugins here.
require 'sass-globbing'

# Set this to the root of your project when deployed:
# http://chriseppstein.github.io/blog/2010/05/17/where-are-your-images/
http_path = "http://metamn.github.io/cs4"
http_images_dir = "assets/images"

css_dir = "components"
sass_dir = "components"
images_dir = "assets/images"
javascripts_dir = "assets/scripts"
fonts_dir = "assets"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = :compact

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass assets scss && rm -rf sass && mv scss sass