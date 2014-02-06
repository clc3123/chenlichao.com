task :default => :preview

desc "preview the site"
task :preview do
  sh 'bundle exec jekyll serve --watch'
end

desc "compile the site"
task :compile do
  sh 'bundle exec jekyll build --config _config.yml,_config_production.yml'
end
