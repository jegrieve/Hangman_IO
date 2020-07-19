class Hangman
    attr_reader :dictionary, :secret_word
    def initialize
        @dictionary = File.readlines("5desk.txt").map(&:chomp)
        @secret_word = random_word
    end

    def random_word
        word = @dictionary.sample
        while word.length  < 5 || word.length > 12
        word = @dictionary.sample
        end
        word
    end
end

a = Hangman.new
p a.secret_word