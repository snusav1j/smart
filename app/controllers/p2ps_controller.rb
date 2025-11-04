class P2psController < ApplicationController
  before_action :set_p2p, only: [:show, :edit, :update, :destroy, :file_destroy]
  before_action :authenticate_user!

  def index
    @p2ps = current_user ? P2p.by_user(current_user.id).buy_orders.reverse : nil
  end

  def show
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
  
  def new
    @p2p = P2p.new
    @p2p.p2p_files.build
  end

  def create
    @p2p = P2p.new(p2p_params)
    @p2p.user_id = current_user.id
    @p2p.p2p_type = P2p::BUY_TYPE

    if @p2p.save
      save_files(@p2p, params[:p2p_files])
      redirect_to p2ps_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @p2p.update(p2p_params)
      save_files(@p2p, params[:p2p_files])
      redirect_to p2p_path(@p2p)
    else
      render :edit
    end
  end

  def file_destroy
    p2p_file = P2pFile.find(params[:file_id])
    remove_file(p2p_file)
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: p2ps_path }
    end
  end

  def destroy
    @p2p.p2p_files.each { |f| remove_file(f) }
    @p2p.p2p_files.destroy_all

    if @p2p.buy?
      @p2p.destroy_orders
      redirect_to p2ps_path
    else
      sell_p2p = P2p.find_by_id(@p2p.sell_order_id)
      @p2p.destroy_orders
      redirect_to sell_p2p_path(sell_p2p)
    end
  end

  private

  def set_p2p
    @p2p = P2p.find(params[:id])
  end

  # Сохраняем файлы в правильной структуре
  def save_files(p2p, files_param)
    return unless files_param.present?

    files_param.each do |_, file_data|
      uploaded_file = file_data[:file] || file_data['file']
      next unless uploaded_file.is_a?(ActionDispatch::Http::UploadedFile)

      dir_path = Rails.root.join('storage', 'uploads', 'p2p_files', current_user.id.to_s, p2p.id.to_s)
      FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)

      timestamp = Time.now.to_i
      sanitized_name = uploaded_file.original_filename.gsub(/[^\w\.\-]/, '_')
      stored_file_name = "#{timestamp}_#{sanitized_name}"
      file_path = dir_path.join(stored_file_name)

      File.open(file_path, 'wb') { |f| f.write(uploaded_file.read) }

      p2p.p2p_files.create!(
        user_id: current_user.id,
        file_name: file_data[:file_name].presence || file_data['file_name'] || uploaded_file.original_filename,
        stored_path: file_path.to_s
      )
    end
  end

  # Удаляем файл и чистим папки
  def remove_file(p2p_file)
    File.delete(p2p_file.stored_path) if File.exist?(p2p_file.stored_path)
    p2p_file.destroy

    # Чистим папку P2P
    p2p_dir = Rails.root.join('storage', 'uploads', 'p2p_files', p2p_file.user_id.to_s, p2p_file.p2p_id.to_s)
    Dir.rmdir(p2p_dir) if Dir.exist?(p2p_dir) && Dir.empty?(p2p_dir)

    # Чистим папку пользователя, если пуста
    user_dir = Rails.root.join('storage', 'uploads', 'p2p_files', p2p_file.user_id.to_s)
    Dir.rmdir(user_dir) if Dir.exist?(user_dir) && Dir.empty?(user_dir)
  end

  def p2p_params
    params.require(:p2p).permit(
      :order_id, :sell_order_id, :rub_per_usd, :order_sum,
      :p2p_type, :bank_id, :bank_comission, :tax_paid,
      :tax_rate, :order_date, :usdt_count, :extra_sell_summ,
      :comission_rub
    )
  end
end
