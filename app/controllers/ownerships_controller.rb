class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: prams[:item_code])
    
    unless @item.persisted?
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.serch(itemCode: @item.code)
      
      @item = Item.new(read(results.first))
      @item.save
    end
    
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品をWantしました。'
    end
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    if params[:type] == 'Want'
      current_user.unwant(@item)
      flash[:success] = '商品をwantを解除しました。'
    end
    
    redirect_back(fallback_location: root_path)
  end
end
