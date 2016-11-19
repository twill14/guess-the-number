require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


def generate_number
  (1..3).to_a.sample
end

def check_bet(bet, max)
  if bet < 1 || bet > max
    session[:message] = "Bets must be between $1 and $#{max}"
    return true
  end
  false
end

configure do
  enable :sessions
  set :session_secret, 'dragons'
end

before do
  session[:total] ||= 100
end

get "/" do 
  redirect "/bet"
end

get "/bet" do
  @total = session[:total]
  erb :bet
end

post "/bet" do
  random_number = generate_number
  guess = params[:guess].to_i
  bet = params[:bet].to_i
  
  redirect "/bet" if check_bet(bet,session[:total])

  if guess == random_number
    session[:message] = "You have guessed correctly!"
    session[:total] += bet
  else
    session[:total] -= bet
    session[:message] = "You guessed #{guess} but the number was #{random_number}"
  end
  

  if session[:total] > 0
    redirect "/bet"
  else
    redirect "/broke"
  end
end

get "/broke" do
  erb :broke
end


# random number
# money = session[:user][:total] - bet_amount
# bet 
# gain/lose