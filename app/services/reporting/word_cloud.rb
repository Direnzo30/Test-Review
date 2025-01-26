module Reporting
  class WordCloud
    attr_accessor :reviews

    COMMON_WORDS = %w[the and a to of in is it you those or that he was for on are as with his they i we have has does at be this have from or by].freeze
    
    def initialize(reviews:)
      @reviews = reviews
    end

    def generate
      words_frequency = Hash.new { |h,k| h[k] = 0 }

      reviews.each do |review|
        words = tokenize(review[:comment])
        words.each { |word| words_frequency[word] += 1 }
      end

      words_frequency
    end

    private

    def tokenize(text)
      text.downcase.scan(/\b[a-z']+\b/).reject { |word| COMMON_WORDS.include?(word) }
    end
  end
end
