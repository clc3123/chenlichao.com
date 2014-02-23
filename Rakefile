
task :default => :preview

desc "preview the site"
task :preview do
  system "bundle exec jekyll serve --drafts --watch"
end

desc "build"
task :build => [:build_site, :build_sitemap]

desc "build site"
task :build_site do
  require 'fileutils'
  system "git pull origin master"
  last_commit = `git log -n 1 --pretty=%H`.strip
  if File.exists?(".last_commit") && File.read(".last_commit") == last_commit
    exit
  else
    FileUtils.rm_rf("_site")
    system "bundle exec jekyll build --config _config.yml,_config_production.yml"
    File.open ".last_commit", "w" do |f|
      f.print last_commit
    end
  end
end

desc "build sitemap.xml"
task :build_sitemap do
  require 'date'
  require 'erb'
  require 'fileutils'
  require 'zlib'
  sleep 3
  source = "_site/pages.txt"
  exit unless File.exists? source
  pages = []
  File.open source do |f|
    f.each do |page|
      page = page.strip
      next if page == ""
      url, path = page.split(" ")
      datetime = `git log -1 --pretty=%ci -- #{path}`
      lastmod = DateTime.parse(datetime).rfc3339
      case url
      when "/index.html"
        url = "/"
        changefreq = "daily"
        priority = "1.0"
        lastmod = Time.now.to_datetime.rfc3339
      when "/404.html"
        next
      when /^\/articles\//
        changefreq = "weekly"
        priority = "0.8"
      when /^\/notes\//
        changefreq = "weekly"
        priority = "0.6"
      else
        changefreq = "monthly"
        priority = "0.4"
      end
      pages << {url: url, changefreq: changefreq, priority: priority, lastmod: lastmod}
    end
  end
  template = File.read "sitemap.xml.erb"
  content = ERB.new(template).result binding
  File.open "_site/sitemap.xml", "w" do |f|
    f.print content
  end
  File.open "_site/sitemap.xml.gz", "w" do |f|
    f.print Zlib::Deflate.deflate(content, 9)
  end
  FileUtils.rm_f source
end

desc "submit sitemap"
task :submit_sitemap do
  require 'openssl'
  require 'net/http'
  require 'uri'
  sitemap = "_site/sitemap.xml"
  n = 3
  while true
    exit if n == 0
    break if File.exists?(sitemap)
    sleep 3
    n -= 1
  end
  last_submit = OpenSSL::Digest.hexdigest('md5', File.read(sitemap))
  if File.exists?(".last_submit") && File.read(".last_submit") == last_submit
    exit
  else
    uri = "http://www.google.com/webmasters/tools/ping?sitemap=" + URI.encode_www_form_component("http://chenlichao.com/sitemap.xml")
    n = 3
    while true
      exit if n == 0
      res = Net::HTTP.get_response URI(uri)
      break if res.code.to_i == 200
      sleep 3
      n -= 1
    end
    File.open ".last_submit", "w" do |f|
      f.print last_submit
    end
  end
end
