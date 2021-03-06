require 'rubygems'
require 'sinatra'
require 'twitter'
require 'haml'

# require 'awesome_print'   # development mode


set :current_conf, 'ops-2012'
set :planned_conf, []

set :conferencies, {
  'ops-2012' => {
    :title  => 'PACEMAKER | OPS Conference, 2012',
    :date => '1 December, 2012',
    :reg_deadline => 'September 5th, 18:00',
    :location => 'Rivne',
    :limit => 50,
    :scheduled => false,
    :vote => false,
    :report => false,
    :reg_open => false
  },
  'lamp-2012' => {
    :title  => 'PACEMAKER | LAMP Conference, 2012',
    :date => '22 September, 2012',
    :reg_deadline => 'September 5th, 18:00',
    :location => 'Ivano-Frankivsk',
    :limit => 80,
    :scheduled => true,
    :vote => false,
    :report => false,
    :reg_open => false
    
  },
  'java-2012' => {
    :title  => 'PACEMAKER | Java Conference, 2012',
    :date => '4 August, 2012',
    :reg_deadline => 'September 5th, 18:00',
    :location => 'Chernivtsi',
    :limit => 75,
    :scheduled => true,
    :vote => false,
    :report => true,
    :reg_open => false
  },
  'js-2012' => {
    :title  => 'PACEMAKER | JS Conference, 2012',
    :date => '7 April, 2012',
    :reg_deadline => 'September 5th, 18:00',
    :location => 'Dnipropetrovsk',
    :limit => 70,
    :scheduled => true,
    :vote => false,
    :report => true,
    :reg_open => false
  }
}

set :haml, :format => :html5

Twitter.configure do |config|
   config.consumer_key = 'iLHqIMRs3roKizOifRog'
   config.consumer_secret = 'T4hETM7yRctra3nIUnmpU3Jex5BhFvHVnBT6uWYIOVA'
   config.oauth_token = '524597088-lazizoKuBNsVDamGjUwQQ6r4q7mQJXzWeFkjMQSC'
   config.oauth_token_secret = 'wHKMKnYUr79aUTDvVQs4XVPKdlNpOF8yJdttYUox05s'
end

get '/twitter' do; erb :twitter, :layout => false; end   # twitter

get '/google50839014440e56f6' do; erb :google50839014440e56f6; end   # GA

get '/t' do
    posts = {}
  Twitter.search("@pacemaker_conf", :result_type => "recent").map do |status|
      posts[status.created_at] = {:user => status.from_user_name, :author => status.from_user, :photo => status.profile_image_url, :msg => status.text}
  end
  Twitter.search("from:@pacemaker_conf", :result_type => "recent").map do |status|
      posts[status.created_at] = {:user => status.from_user_name,  :author => status.from_user, :photo => status.profile_image_url, :msg => status.text}
  end
  Twitter.search("#pacemaker_conf", :result_type => "recent").map do |status|
      posts[status.created_at] = {:user => status.from_user_name,  :author => status.from_user, :photo => status.profile_image_url, :msg => status.text}
  end
  
  tweets = posts.keys.sort{|x, y| y <=> x}.inject({}){|tweets, key| tweets[key] = posts[key]; tweets}
  tweets.to_json
end


get '/' do
  redirect to(settings.current_conf)
end

get '/:conf/slides/:file' do |conf, file|
  redirect to("/slides/#{conf}/#{file}")
end

get '/:conf' do |conf|
  # redirect to("#{conf}/#{settings.current_conf == conf ? 'about' : 'report'}")
  redirect to("#{conf}/about")
end

get '/:conf/register' do |conf|
  if settings.conferencies[conf][:reg_open]
    set :conf, conf
    set :page, 'register'
    erb :"#{conf}/register"
  else
    redirect to("#{conf}/about")
  end
end

get '/:conf/:page' do |conf, page|
  set :conf, conf
  set :page, page
  erb :"#{conf}/#{page}"
end



################ JS 2012 temp ################
# 
# get '/7-apr-2012-js' do
#   File.read('public/js-2012/index.html')
# end
# 
# get '/7-apr-2012-js/report' do
#   File.read('public/js-2012/report.html')
# end
