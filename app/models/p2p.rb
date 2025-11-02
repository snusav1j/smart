class P2p < ApplicationRecord
  has_many :p2p_files, dependent: :destroy

  BUY_TYPE = 0
  SELL_TYPE = 1

  scope :buy_orders, -> { where(p2p_type: BUY_TYPE) }
  scope :sell_orders, -> { where(p2p_type: SELL_TYPE) }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id }

  def tax_paid?
    self.tax_paid == true
  end

  def calculate_tax
    if self.buy?
      sell_orders = P2p.where(sell_order_id: self.id)
      if sell_orders && self
        tax_sum = ((self.tax_rate || 13) / 100) * self.calculate_profit
        return tax_sum.round(2)
      else
        0
      end
    else
      0
    end
  end

  def total_buy_sum
    total_buy_sum = 0
    total_buy_sum += self.usdt_count * self.rub_per_usd if self.usdt_count && self.rub_per_usd
    total_buy_sum += self.comission_rub if self.comission_rub
    total_buy_sum.round(2)
  end

  def self.get_sell_orders_by(p2p)
    self.where(sell_order_id: p2p.id) if p2p
  end
  
  def self.calculate_total_profit(p2ps)
    if p2ps
      total_profit = 0
      p2ps.each do |p2p|
        total_profit += p2p.calculate_profit
      end
      return total_profit.round(2)
    else
      0
    end
  end
  
  def self.calculate_total_profit_with_taxes(p2ps)
    if p2ps
      total_profit = 0
      p2ps.each do |p2p|
        tax_sum = ((p2p.tax_rate || 13) / 100) * p2p.calculate_profit
        total_profit += p2p.calculate_profit
        total_profit -= tax_sum
      end
      return total_profit.round(2)
    else
      0
    end
  end

  def usdt_remains
    if self.buy?
      sell_orders = P2p.where(sell_order_id: self.id)
      if sell_orders && self
        remains = 0
        buy_usdt_count = self.usdt_count
        sell_orders.each do |sell_order|
          sell_usdt_count = sell_order.usdt_count
          remains += (buy_usdt_count - sell_usdt_count)
        end
        return remains.round(2)
      else
        0
      end
    else
      buy_order = P2p.find_by(id: self.id)
      if buy_order && self
        buy_sum = buy_order.order_sum
        sell_sum = self.order_sum
        
        return (sell_sum - buy_sum).round(2)
      else
        0
      end
    end
  end

  def calculate_profit
    if self.buy?
      sell_orders = P2p.where(sell_order_id: self.id)
      if sell_orders && self
        profit = 0
        profit -= self.comission_rub if self.comission_rub
        buy_sum = self.usdt_count * self.rub_per_usd
        sell_orders.each do |sell_order|
          sell_sum = sell_order.usdt_count * sell_order.rub_per_usd
          profit += (sell_sum - buy_sum)
          profit += sell_order.extra_sell_summ if sell_order.extra_sell_summ
          profit += self.usdt_remains * sell_order.rub_per_usd
        end

        return profit.round(2)
      else
        0
      end
    else
      buy_order = P2p.find_by(id: self.id)
      if buy_order && self
        buy_sum = buy_order.order_sum
        sell_sum = self.order_sum
        
        return (sell_sum - buy_sum).round(2)
      else
        0
      end
    end
  end

  def calculate_profit_with_taxes
    if self.buy?
      sell_orders = P2p.where(sell_order_id: self.id)
      if sell_orders && self
        profit = 0
        profit -= self.comission_rub if self.comission_rub
        buy_sum = self.usdt_count * self.rub_per_usd
        sell_orders.each do |sell_order|
          sell_sum = sell_order.usdt_count * sell_order.rub_per_usd
          profit += (sell_sum - buy_sum)
          profit += sell_order.extra_sell_summ if sell_order.extra_sell_summ
          profit += self.usdt_remains * sell_order.rub_per_usd
        end
        #tax
        tax_sum = ((self.tax_rate || 13) / 100) * profit
        profit -= tax_sum 
        return profit.round(2)
      else
        0
      end
    else
      0
    end
  end

  def calculate_profit_without_remains
    if self.buy?
      sell_orders = P2p.where(sell_order_id: self.id)
      if sell_orders && self
        profit = 0
        profit -= self.comission_rub if self.comission_rub
        buy_sum = self.usdt_count * self.rub_per_usd
        sell_orders.each do |sell_order|
          sell_sum = sell_order.usdt_count * sell_order.rub_per_usd
          profit += (sell_sum - buy_sum)
          profit += sell_order.extra_sell_summ if sell_order.extra_sell_summ
        end
        return profit.round(2)
      else
        0
      end
    else
      buy_order = P2p.find_by(id: self.id)
      if buy_order && self
        buy_sum = buy_order.order_sum
        sell_sum = self.order_sum
        
        return (sell_sum - buy_sum).round(2)
      else
        0
      end
    end
  end

  def destroy_orders
    p2p_id = self.id
    self.delete
    p2p_sell = P2p.where(sell_order_id: p2p_id)
    p2p_sell.delete_all if p2p_sell
  end

  def buy?
    self.p2p_type == BUY_TYPE
  end

  def sell?
    self.p2p_type == SELL_TYPE
  end
  
  def p2p_type_name
    if self.buy?
      'Покупка'
    else
      'Продажа'
    end
  end
end