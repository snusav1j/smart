class P2psController < ApplicationController
  before_action :set_p2p, only: [:show, :edit, :update, :destroy]

  def index
    @p2ps = current_user ? P2p.by_user(current_user.id).buy_orders.reverse : nil
  end

  def show
  end

  def new
    @p2p = P2p.new()
  end

  def create
    @p2p = P2p.new(p2p_params)
    @p2p.user_id = current_user.id
    @p2p.p2p_type = P2p::BUY_TYPE
    @created = @p2p.save
    
    redirect_to p2ps_path
  end

  def edit

  end

  def sell_order
    @p2p_sell = P2p.new(p2p_params)
    @p2p_sell.user_id = current_user.id
    @p2p_sell.p2p_type = P2p::SELL_TYPE
    @created = @p2p_sell.save
    if @created
      @p2p = P2p.find_by_id(p2p_params[:sell_order_id])
    end
    # redirect_to p2ps_path
    redirect_to sell_p2p_path(@p2p)
  end

  def sell
    @p2p = P2p.find_by_id(params[:id])
    @p2p_sell = P2p.new()
  end

  def update
    @p2p.update(p2p_params)
    redirect_to p2p_path(@p2p)
  end
  
  def destroy
    if @p2p.buy?
      @p2p.destroy_orders
      redirect_to p2ps_path
    else
      @sell_p2p = P2p.find_by_id(@p2p.sell_order_id)
      @p2p.destroy_orders
      redirect_to sell_p2p_path(@sell_p2p)
    end
  end

  private

  def set_p2p
    @p2p = P2p.find(params[:id])
  end

  def p2p_params
    params.require(:p2p).permit(
      :order_id,
      :sell_order_id,
      :rub_per_usd,
      :order_sum,
      :p2p_type,
      :bank_id,
      :bank_comission,
      :tax_paid,
      :tax_rate,
      :order_date,
      :usdt_count,
      :extra_sell_summ,
      :comission_rub
    )
  end

end
