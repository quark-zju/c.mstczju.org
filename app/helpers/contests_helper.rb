# coding: utf-8
module ContestsHelper
  PRICE_PRIMES = {2 => true, 3 => true, 5 => true, 7 => true, 11 => true, 13 => true, 17 => true, 19 => true, 23 => true, 29 => true, 31 => true, 37 => true, 41 => true, 43 => true, 47 => true, 53 => true, 59 => true, 61 => true, 67 => true, 71 => true, 73 => true, 79 => true, 83 => true, 89 => true, 97 => true, 101 => true, 103 => true, 107 => true, 109 => true, 113 => true, 127 => true, 131 => true, 137 => true, 139 => true, 149 => true}
  
  PRICE_NAMES = ['神秘奖', '耳机', 'Usb Hub', '巧克力']
  
  def price_count_reset
    @remaining_price_counts = [1, 35, 114, 500]
  end

  def price_name(price_id)
    #TODO
    PRICE_NAMES[price_id] 
  end

  def price_for(rank)
    price_id = if rank == 1
                 0
               elsif PRICE_PRIMES[rank]
                 1
               elsif rank <= 150
                 2
               else
                 3
               end
    price_name price_id
  end
end
