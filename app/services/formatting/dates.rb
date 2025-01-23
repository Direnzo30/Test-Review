module Formatting
  class Dates
    class << self
      # Date string can come like: today, yesterday, 1 week ago, 1 month ago, January 2025
      def month_and_year(date_string)
        downcased = date_string.downcase
        values = date_string.split(" ")
        days_to_substract = 0

        if downcased.include? "today"
          days_to_substract = 0.days
        elsif downcased.include? "yesterday"
          days_to_substract = 1.days
        elsif downcased.include? "day"
          days_to_substract = values[0].to_i.days
        elsif downcased.include? "week"
          days_to_substract = values[0].to_i.week
        # This is for the case Month - Year
        else
          return [values[0], values[1]]
        end
        date = Time.now - days_to_substract
        [::Date::MONTHNAMES[date.month], date.year]
      end
    end
  end
end
