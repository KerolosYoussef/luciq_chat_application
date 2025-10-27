class ApplicationsController < BaseController
  before_action :set_application, only: %i[ show update ]

  # GET /applications?page={pageIndex}&per_page={page_size}
  def index
    applications_dto = Applications::PaginationService.call(params[:page], params[:per_page])

    render json: applications_dto, status: :ok
  end

  # GET /applications/{token}
  def show
    render json: ApplicationDto.new(@application)
  end

  # POST /applications
  def create
    @application = Applications::CreateService.call(application_params)

    if @application.save
      render json: ApplicationDto.new(@application), status: :created
    else
      render json: @application.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /applications/{token}
  def update
    if @application.update(application_params)
      render json: ApplicationDto.new(@application)
    else
      render json: @application.errors, status: :unprocessable_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(token: params[:token])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.expect(application: [ :name ])
    end
end
