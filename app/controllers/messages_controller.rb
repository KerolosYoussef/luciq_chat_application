class MessagesController < BaseController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [:show, :update]

  # GET /applications/{token}/chats/{chat_number}/messages?page={pageIndex}&per_page={page_size}
  def index
    messages_dto = Messages::PaginationService.call(@chat, @application, params[:page], params[:per_page])
    render json: messages_dto, status: :ok
  end

  # GET /applications/{token}/chats/{chat_number}/messages/search?q=keyword&page=1&per_page=25
  def search
    if params[:q].blank?
      render json: { error: 'Query parameter "q" is required' }, status: :bad_request
      return
    end

    results = Messages::SearchService.call(
      @chat,
      @application,
      params[:q],
      params[:page],
      params[:per_page]
    )

    render json: results, status: :ok
  end

  # GET /applications/{token}/chats/{chat_number}/messages/{number}
  def show
    render json: MessageDto.new(@message, @chat.number, @application.token)
  end

  # POST /applications/{token}/chats/{chat_number}/messages
  def create
    @message = Messages::CreateService.call(@application, @chat, params[:body])
    render json: @message, status: :created
  end

  # PATCH/PUT /applications/{token}/chats/{chat_number}/messages/{number}
  def update
    if @message.update(messages_params)
      render json: MessageDto.new(@message, @chat.number, @application.token)
    else
      render json: @message.errors, status: :unprocessable_content
    end
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end
  def set_chat
    @chat = @application.chats.find_by!(number: params[:chat_number])
  end
  def set_message
    @message = @chat.messages.find_by!(number: params[:number])
  end

  def messages_params
    params.expect(message: [ :body ])
  end
end
