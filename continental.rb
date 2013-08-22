require 'sinatra'
require 'slim'
require 'data_mapper'

enable :sessions

#=begin
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Player
  attr_accessor :name, :score

  def initialize(name, score = 0)
    @name = name
    @score = score
  end
end
#DataMapper.finalize

get '/' do
  session["names"] ||= nil
  slim :index 
end

post '/' do
  @player = params[:players].to_i
  @decks = (@player + 1 )/2
  slim :players
end

post '/names' do
  session[:players] = Array.new
  params[:names].each do |id|
    session[:players].push(Player.new(id))
  end
  session[:round]=1
  redirect to('/round')
end

get '/round' do
  @round = session[:round]
  @players = session[:players]
  slim :round
end
