desc "preview the site"
task :default do
  pid = spawn 'bundle exec jekyll serve --watch'

  trap 'INT' do
    Process.kill 'INT', pid
    exit 1
  end

  loop do
    sleep 1
  end
end

desc "compile the site"
task :compile do
  system 'bundle exec jekyll build --config _config.yml,_config_production.yml'
end
