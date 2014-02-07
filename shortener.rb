require 'sinatra'
require 'active_record'
require 'digest/sha1'
require 'pry'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
  has_many :clicks

  attr_accessible :url, :code

  validates :url, :presence => true
  validates_uniqueness_of :code

  def increment_count
    update_attribute :count, count+1
  end

  before_save do |record|
    record.code = Digest::SHA1.hexdigest(record.url)[0,4]
  end
end

class Click < ActiveRecord::Base
  belongs_to :link
end

###########################################################
# Routes
###########################################################

get '/' do
  @links = Link.order('created_at desc').all
  erb :index
end

get '/new' do
  erb :form
end

post '/new' do
  link = Link.find_or_create_by_url :url => params[:url]
  link.code
end

get '/:code' do
  link = Link.find_by_code params[:code]
  if link.nil?
    # do something
  else
    link.clicks.create
    #link.increment_count
    redirect 'http://' + link.url
  end
end


