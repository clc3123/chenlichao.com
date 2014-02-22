
task :default => :preview

desc "preview the site"
task :preview do
  sh 'bundle exec jekyll serve --drafts --watch'
end

desc "generate sitemap.xml"
task :sitemap do
  require 'date'
  require 'erb'
  require 'fileutils'

  source = File.expand_path("../_site/pages.txt", File.realpath(__FILE__))
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
  template = File.read File.expand_path("../sitemap.xml.erb", File.realpath(__FILE__))
  content = ERB.new(template).result binding
  File.open File.expand_path("../_site/sitemap.xml", File.realpath(__FILE__)), "w" do |f|
    f.puts content
  end
  FileUtils.rm_f source
end
