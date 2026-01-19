class TagsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tag = Tag.new
  end

  def create
    @tag = current_user.tags.build(tag_params)

    if @tag.save
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_back fallback_location: new_shop_path,
                        notice: "タグを追加しました"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render :new, status: :unprocessable_entity
        end

        format.html do
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :color_class)
  end
end
