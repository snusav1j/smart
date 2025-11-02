class P2pSell < ApplicationRecord
  belongs_to :p2p

  def self.calculate_orders_sum
    p2p_sells_order_sum = 0
    if self
      self.all.each do |p2p_sell|
        p2p_sells_order_sum += p2p_sell.order_sum
      end
    end
    p2p_sells_order_sum
  end
end