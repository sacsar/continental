require 'sinatra'
require 'slim'
#require 'data_mapper'

enable :sessions
set :session_secret, '12310afldskjf220194'

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
  session.clear
  slim :index 
end

post '/' do
  @player = params[:players].to_i
  @decks = (@player + 1 )/2
  session[:decks] = @decks
  session[:players] = []
  slim :players
end

post '/names' do
  session[:players] = Array.new
  params[:names].each do |id|
    session[:players].push(Player.new(id.last))
  end
  session[:round]=1
  redirect to('/round')
end

get '/round' do
  @round = session[:round]
  @players = session[:players]
  @decks = session[:decks]
  session[:round] = @round + 1
  slim :round
end

post '/round' do
  players = session[:players]
  output = ""
  players.each_index do |i|
    j = i.to_s
    score = 5*(params[:others][i.to_s].to_i) + 10*(params[:tens][i.to_s].to_i+params[:jacks][i.to_s].to_i+params[:queens][i.to_s].to_i+params[:kings][i.to_s].to_i) + 20*params[:aces][i.to_s].to_i + 50*params[:jokers][i.to_s].to_i
    players[i].score = players[i].score.to_i + score.to_i
  end
  session[:players] = players
  redirect to('/round')
end
