require "yaml"
class Hangman
    attr_reader :dictionary, :current_guess, :previous_guesses
    def initialize(secret_word = "", guesses_remaining =  5, previous_guesses = [], current_guess = [])
        @dictionary = File.readlines("5desk.txt").map(&:chomp)
        @secret_word = secret_word
        @guesses_remaining = guesses_remaining
        @previous_guesses = previous_guesses
        @current_guess = current_guess
        run
    end

    def run
        puts "Welcome to Hangman!"
        initialize_secret_word
        initialize_guess_array
        while !win?
        display
        break if lose?
        guess = get_input
        return if guess == "exit"
        if guess == "save"
            save_game
        else
        while !valid_input?(guess)
            puts "Invalid input, please try a different letter."
            guess = get_input
        end
        lose_guess if !good_guess(guess) || already_attempted(guess)
        self.previous_guesses << guess
        end
    end
        puts "Game Over"
    end

    def save_game
        File.write("saved_game.yaml", to_yaml)
    end

    def word_picker
        invalid_length = true
        while invalid_length
            word = self.dictionary.sample
            invalid_length = false if word.length >= 5 && word.length <= 12
        end
        word
    end

    def display
        puts "Guesses remaining: #{@guesses_remaining}"
        puts "Previous guesses: #{@previous_guesses}"
        puts "Current guess: #{@current_guess}"
        puts "Type \"save\" to save current game"
        puts "Type exit to exit game"
    end

    def good_guess(guess)
        word = self.secret_word.split("")
        guess = guess.downcase
        good_gs = false
        word.each_with_index do |letter,i|
            if letter == guess
                current_guess[i] = guess
                good_gs = true
            end
        end
        good_gs
    end

    def get_input
        puts "Please enter a guess letter"
        invalid = true
        guess = gets.chomp
        guess
    end

    def win?
        if !@current_guess.include?("_")
            puts "You Win!"
            return true
        end
        false
    end

    def lose?
         if @guesses_remaining == 0
            puts "You Lose!"
            return true
         end
         false
    end

    def valid_input?(guess)
        az = ('a'..'z').to_a
        az_upper = ("A".."Z").to_a
        return true if (az.include?(guess) || az_upper.include?(guess)) && !previous_guesses.include?(guess)
        false
    end

    def already_attempted(guess)
        return true if self.previous_guesses.include?(guess)
        false
    end

    #save/load YAML
    def to_yaml
        YAML.dump ({
            :guesses_remaining => @guesses_remaining,
            :previous_guesses => @previous_guesses,
            :current_guess => @current_guess,
            :secret_word => @secret_word
        })
    end

    def self.from_yaml(file_name)
        data = YAML.load(file_name)
        self.new(data[:guesses_remaining], data[:previous_guesses], data[:current_guess], data[:secret_word])
    end

    private
    def secret_word
        @secret_word
    end

    def secret_word=(new_word)
        @secret_word = new_word
    end

    def lose_guess
        @guesses_remaining -= 1
    end

    
    def initialize_secret_word
        self.secret_word = word_picker
    end

    def initialize_guess_array
        self.secret_word.length.times {current_guess << "_"}
    end

end

puts "Press n for new game or l to load past game"
command = gets.chomp.downcase
case command
when "n"
    Hangman.new
when "l"
    Hangman.from_yaml(File.open("saved_game.yaml"))
else
    puts "Sorry that command is not recognized"
end