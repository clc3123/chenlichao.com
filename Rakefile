task :default => :preview

desc "preview"
task :preview do
  system "bundle exec jekyll serve --drafts --watch"
end

desc "build"
task :build, [:phase] do |t, args|
  args.with_defaults(:phase => "production")
  test = (args.phase == "test" ? true : false)
  require 'date'
  require 'erb'
  require 'fileutils'
  require 'zlib'
  system "git pull origin master" unless test
  last_commit = `git log -n 1 --pretty=%H`.strip
  if File.exists?(".last_built_commit") && File.read(".last_built_commit") == last_commit
    exit
  else
    puts "building site on commit #{last_commit}"
    FileUtils.rm_rf("_site")
    system "bundle exec jekyll build --config _config.yml,_config_production.yml"
    File.open ".last_built_commit", "w" do |f|
      f.write last_commit
    end

    puts "building sitemap"
    source = "_site/pages.txt"
    layout_datetime = %w(
      _layouts/default.html
      _config.yml
      _config_production.yml
    ).map do |f|
      DateTime.parse(`git log -n 1 --pretty=%ci -- #{f}`.strip)
    end.max
    post_layout_datetime = [layout_datetime, DateTime.parse(`git log -n 1 --pretty=%ci -- _layouts/post.html`.strip)].max

    pages = []
    File.open source do |f|
      f.each do |page|
        page = page.strip
        next if page == ""
        url, path = page.split(" ")
        datetime = DateTime.parse(`git log -n 1 --pretty=%ci -- #{path}`.strip)
        datetime = [datetime, layout_datetime].max
        case url
        when "/index.html"
          url = "/"
          changefreq = "daily"
          priority = "1.0"
          datetime = Time.now.to_datetime
        when "/404.html"
          next
        when /^\/articles\//
          changefreq = "weekly"
          priority = "0.8"
          datetime = [datetime, post_layout_datetime].max
        when /^\/notes\//
          changefreq = "weekly"
          priority = "0.6"
          datetime = [datetime, post_layout_datetime].max
        else
          changefreq = "monthly"
          priority = "0.4"
        end
        page_item = {url: url, changefreq: changefreq, priority: priority, lastmod: datetime.rfc3339}
        if page_item[:url] == "/"
          pages.unshift page_item
        else
          pages << page_item
        end
      end
    end
    template = File.read "sitemap.xml.erb"
    content = ERB.new(template).result binding
    File.open "_site/sitemap.xml", "w" do |f|
      f.write content
    end
    Zlib::GzipWriter.open "_site/sitemap.xml.gz", 9 do |gz|
      gz.orig_name = "sitemap.xml"
      gz.write File.read("_site/sitemap.xml")
    end
    Zlib::GzipReader.open "_site/sitemap.xml.gz" do |gz|
      puts gz.read(512)
    end if test
  end
  FileUtils.rm_f ".last_built_commit" if test
end

desc "submit sitemap"
task :submit_sitemap, [:phase] do |t, args|
  args.with_defaults(:phase => "production")
  test = (args.phase == "test" ? true : false)
  Rake::Task["build"].invoke("test") if test
  require 'openssl'
  require 'net/http'
  require 'uri'
  sitemap = "_site/sitemap.xml"
  exit unless File.exists?(sitemap)
  last_sitemap = OpenSSL::Digest.hexdigest('md5', File.read(sitemap))
  if File.exists?(".last_submitted_sitemap") && File.read(".last_submitted_sitemap") == last_sitemap
    exit
  else
    puts "submitting sitemap.xml"
    uri = "http://www.google.com/webmasters/tools/ping?sitemap=" + URI.encode_www_form_component("http://chenlichao.com/sitemap.xml")
    n = 3
    puts uri
    while true
      exit if n == 0
      res = Net::HTTP.get_response URI(uri)
      if res.code.to_i == 200
        puts res.code
        puts res.body
        break 
      end
      sleep 3
      n -= 1
    end
    File.open ".last_submitted_sitemap", "w" do |f|
      f.write last_sitemap
    end
  end
  FileUtils.rm_f ".last_submitted_sitemap" if test
end
