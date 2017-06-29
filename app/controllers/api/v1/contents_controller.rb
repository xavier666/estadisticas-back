class Api::V1::ContentsController < Api::V1::ApiController

  def index
    @contents = Content.all
    expose @contents
  end

end