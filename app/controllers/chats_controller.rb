class ChatsController < BaseController
  before_action :set_application
  before_action :set_chat, only: [:show]

  # GET /applications/{token}/chats?page={pageIndex}&per_page={page_size}
  def index
    chats_dto = Chats::PaginationService.call(@application, params[:page], params[:per_page])
    render json: chats_dto, status: :ok
  end

  # GET /applications/{token}/chats/{number}
  def show
    render json: ChatDto.new(@chat, params[:application_token])
  end

  # POST /applications/{token}/chats
  def create
    @chat = Chats::CreateService.call(@application)

    render json: @chat, status: :created
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end
  def set_chat
    @chat = @application.chats.find_by!(number: params[:number])
  end
end
