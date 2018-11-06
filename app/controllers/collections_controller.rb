class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]

  def index
  	@collections = Collection.all.page params[:page]
  end

  def import
  end

  def show; end

  def new
    @collection = Collection.new
  end

  def edit; end

  def create
    @collection = Collection.new(collection_params)
    if @collection.save
      redirect_to [Collection], notice: 'Collection was successfully created.'
    else
      render :new
    end
  end

  def update
    if @collection.update(collection_params)
      redirect_to Collection, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to Collection, notice: 'Collection deleted'
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.fetch(:collection, {}).permit(:name, :import_type, :import_folder)
  end
end
