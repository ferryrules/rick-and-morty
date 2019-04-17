require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'
require 'rickmorty'

# MVP
# - create a new user in database - done
# - save planet or alien data to database and associate it with user - done
# - view user's database

# INTRO & LOGIN
puts "Intro message. What's your username?"
username = gets.chomp

# POPULATE ALIEN & PLANET TABLE IF FIRST TIME

aliens = []
i = 1
if !User.find_by(name: username)
  puts "Please wait"
  while i < 100
    aliens << (JSON.parse(RestClient.get("https://rickandmortyapi.com/api/character/#{i}").body))
    print "."
    i += 1
  end
end

# PLANETS CREATED FROM ALIEN
# aliens = Rickmorty::Character.new
aliens.each do |alien|
  if !!alien["origin"]["name"]
    planets = Planet.find_or_create_by(name:ali["origin"]["name"])
    Alien.find_or_create_by(name: alien["name"], status: alien["status"], species: alien["species"], planet_id: planets.id, points: alien["name"].length)
  end
end

@current_user = User.find_or_create_by(name: username)
Mortydex.find_or_create_by(user_id: @current_user.id)

# PLANETS
# planets = Rickmorty::Location.new
# planets_db = planets.all.each do |planet|
#   Planet.find_or_create_by(name: planet["name"])
#   # binding.pry
# end



# MAIN MENU
main_menu = "Choose Your Next Move:
      1.Go to Random Planet
      2.Select a Planet
      3.View Mortydex
      4.Go Home(Quit)
      5.View High Scores"

@random_planet = Planet.all.sample
@alien = Alien.all.where("planet_id = ?", @random_planet.id)
# @alien = Alien.all.where("planet_id = ?", 12).sample

puts main_menu

# INSTANCE METHODS
def create_alien
  puts "It looks like this is a new planet! Create and Save the new alien? yes/no "
  while yn = gets.chomp
    case yn.downcase
    when "yes"
      puts "Enter name: "
      name = gets.chomp
      puts "Species? "
      species = gets.chomp
      @current_user.aliens << Alien.find_or_create_by(name: name, status: "Alive", species: species, planet_id: @random_planet.id, points: name.length)
      break
    when "no"
      puts "Fine! Whatever!"
      break
    else
      puts "YES or NO! It's not that hard!"
    end
  end
end

def collect_alien
  current_alien = @alien.sample
  puts "You bump into #{current_alien.name}"
  puts "Save them to your Mortydex? (Yes/No)"
  while yn = gets.chomp
    case yn.downcase
    when "yes"
      @current_user.aliens << Alien.find_or_create_by(name: current_alien.name, status: current_alien.status, species: current_alien.species, planet_id: current_alien.planet_id, points: current_alien.name.length)
      puts "#{current_alien.name}: Awesome, see you soon!"
      break
    when "no"
      puts "#{current_alien.name}: Fine! Whatever!"
      break
    else
      puts "YES or NO! It's not that hard!"
    end
  end
end

# SELECT A PLANET INPUT
while user_input = gets.chomp
  case user_input
    when "1"
      # binding.pry
      puts @random_planet.name
      puts @alien.size < 1 ? create_alien : collect_alien
      puts main_menu
    when "3"
      @current_user.mortydex
      puts main_menu
    when "4"
      puts "Rick is disappointed. Ok Bye!"
      break
    when "5"
      puts @current_user.aliens.sum(:points)
      puts main_menu
  end
end



binding.pry
