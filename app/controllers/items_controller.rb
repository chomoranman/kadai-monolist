class ItemsController < ApplicationController
  def new
    @items = []
    
    @keyword = params[:keyword]
    if @keyword.present? # 
      keyword_ary = @keyword.gsub('　', ' ').split(' ')
      @keyword = keyword_ary.each{ |o| keyword_ary.delete(o) if o.size <= 1}.join(' ')
      render 'new' if @keyword.nil?
      
      if @keyword.present?
        results = RakutenWebService::Ichiba::Item.search({
          keyword: @keyword,
          imageFlag: 1,
          hits: 20,
        })
        
        results.each do |result|
          item = Item.find_or_initialize_by(read(result))
          @items << item
        end
      end
    end
    if @items.blank?
      flash.now[:danger] = "見つかりません。"
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
end
