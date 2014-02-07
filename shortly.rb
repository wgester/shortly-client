require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'digest/sha1'
require 'pry'
require 'uri'
require 'open-uri'

# require 'nokogiri'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    set :sessions, true
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

# turn off root element rendering in JSON
ActiveRecord::Base.include_root_in_json = false


###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html
class User < ActiveRecord::Base
    # def authenticate(password)
    #     (Digest::SHA1.hexdigest "#{password}#{self.salt}") == self.password
    # end

    # has_many :links

    # validates :user_name, presence: true

    # before_save do |user|
    #   randomstring = (0...8).map { (65 + rand(26)).chr }.join
    #   user.salt = Digest::SHA1.hexdigest randomstring
    #   user.password = Digest::SHA1.hexdigest ("#{user.password}#{user.salt}")
    # end
end

class Link < ActiveRecord::Base
    has_many :clicks

    validates :url, presence: true

    before_save do |record|
        record.code = Digest::SHA1.hexdigest(url)[0,5]
    end
end

class Click < ActiveRecord::Base
    belongs_to :link, counter_cache: :visits
end

###########################################################
# Routes
###########################################################

# before '/' do
#     halt redirect('/login') unless logged_in?
# end

get '/' do
    # username = puts session['userinfo']
    # User.find_by user_name: username
    erb :layout
end

# get '/login' do
#     erb :login
# end

get '/newuser' do
    erb :newuser
end

# post '/login' do
#     user = User.find_by_user_name params[:user_name]
#     if user.nil?
#         redirect '/newuser'
#     else
#         if user.authenticate(params[:password])
#             session['user_id'] = user.id
#             redirect '/'
#         else
#             redirect '/login'
#         end
#     end
# end

get '/links' do
    links = Link.order(":clicks_count DESC")
    links.map { |link|
        link.as_json.merge(base_url: request.base_url)
    }.to_json
end

# post '/newuser' do
#     username = params[:user_name]
#     founduser = User.find_by_user_name username
#     if founduser != nil
#         redirect '/login'
#     else
#         user = User.new(params);
#         user.save
#         puts 'user was created!'
#         session['user_id'] = user.id
#         redirect '/'
#     end
# end

post '/links' do
    session['userinfo']
    data = JSON.parse request.body.read
    uri = URI(data['url'])
    raise Sinatra::NotFound unless uri.absolute?
    link = Link.find_by_url(uri.to_s) ||
           Link.create( url: uri.to_s, title: get_url_title(uri) )
    link.as_json.merge(base_url: request.base_url).to_json
end

get '/:url' do
    link = Link.find_by_code params[:url]
    raise Sinatra::NotFound if link.nil?
    link.clicks.create!
    redirect link.url
end

###########################################################
# Utility
###########################################################

# def logged_in?
#     puts session['user_id']
#     session['user_id'] != nil
# end

def read_url_head url
    head = ""
    url.open do |u|
        begin
            line = u.gets
            next  if line.nil?
            head += line
            break if line =~ /<\/head>/
        end until u.eof?
    end
    head + "</html>"
end

def get_url_title url
    # Nokogiri::HTML.parse( read_url_head url ).title
    result = read_url_head(url).match(/<title>(.*)<\/title>/)
    result.nil? ? "" : result[1]
end
