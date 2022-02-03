# frozen_string_literal: true

image_name = 'feed2json'

desc 'Build docker image for Lambda'
task :build do
  system("docker build -t #{image_name}-lambda .")
end

desc 'Package Lambda'
task package: :build do
  exec("docker run --rm -v #{Dir.pwd}/dist:/dist #{image_name}-lambda zip -r /dist/package.zip . " \
       "-x '*.git*' -x 'dist/*' -x '.bundle/*'")
end
