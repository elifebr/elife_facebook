module ElifeFacebook
  class LimitProvider
    class ReduceAmmountReachedBottomException < StandardError ; end

    def initialize
      @max = 50
    end

    def limit i
      amount = case i
      when 0
        10
      when 1
        20
      when 2
        35
      else
        50
      end

      [amount, @max].max
    end

    def reduce_amount
      if @max == 1
        raise ReduceAmmountReachedBottomException
      else
        @max = [(@max - 10), 1].max.tap {|amount|
          ElifeFacebook.logger.debug "reducing amount to #{amount}"
        }
      end
    end
  end
end