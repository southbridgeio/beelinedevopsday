# frozen_string_literal: true

# Контроллер сниппетов
class PastesController < ApplicationController
  before_action :set_paste, only: [:show, :edit, :update, :destroy]

  DEFAULT_TTL_DAYS = 730

  # GET /pastes
  # GET /pastes.json
  def index
    @pastes = Paste.all
    redirect_to root_url
  end

  # GET /pastes/1
  # GET /pastes/1.json
  def show
    @paste.destroy if @paste.auto_destroy? && params[:destroy].present?
  end

  def help
    @html_title = 'Help - xPaste'
  end

  def new
    @paste = Paste.new(ttl_days: DEFAULT_TTL_DAYS)
  end

  # GET /pastes/1/edit
  def edit
    redirect_to paste_url(@paste)
  end

  # curl -d "paste[language]=text" -d "paste[body]=text" localhost:3000/paste
  # curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"paste":{"language":"text","body":"text", "ttl_days": 365}}'  http://localhost:3000/paste

  # curl -X POST localhost:3000/paste -d ''

  # POST /pastes
  # POST /pastes.json
  def create
    @paste = Paste.new(paste_params)
    @paste.referer = request.env['HTTP_REFERER']
    @paste.request = request.env['REQUEST_URI']
    @paste.ip = request.remote_ip

    @paste.ttl_days = DEFAULT_TTL_DAYS unless paste_params && paste_params[:ttl_days].present?

    respond_to do |format|
      if @paste.save
        format.html do
          if session.present?
            redirect_to paste_url(@paste), notice: 'Paste was successfully created.'
          else
            render body: paste_url(@paste)
          end
        end
        format.text { render :show }
        format.json { render :show, status: :created, location: @paste }
      else
        format.html do
          if session.present?
            render :new
          else
            render body: @paste.errors.full_messages.join('; ')
          end
        end
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_file
    language = params[:language]
    request_body = request.body.read.force_encoding('UTF-8')

    body = request_body.strip.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')

    if body.length > 512 * 1024
      cut_message = "\nText was automatically cut over 512 kb"
      body = body[0, 512 * 1024 - cut_message.length] + cut_message
    end

    @paste = Paste.new(
      language: language,
      body: body,
      auto_destroy: params[:auto_destroy].present?
    )
    @paste.referer = request.env['HTTP_REFERER']
    @paste.request = request.env['REQUEST_URI']
    @paste.ip = request.remote_ip
    @paste.ttl_days = params[:ttl_days] || DEFAULT_TTL_DAYS

    if @paste.save
      render body: paste_url(@paste)
    else
      render body: @paste.errors.full_messages.join('; ')
    end
  end

  # PATCH/PUT /pastes/1
  # PATCH/PUT /pastes/1.json
  def update
    respond_to do |format|
      if @paste.update(paste_params)
        format.html { redirect_to paste_url(@paste), notice: 'Paste was successfully updated.' }
        format.json { render :show, status: :ok, location: @paste }
      else
        format.html { render :edit }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pastes/1
  # DELETE /pastes/1.json
  def destroy
    @paste.destroy
    respond_to do |format|
      format.html { redirect_to pastes_url, notice: 'Paste was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_paste
    @paste = Paste.find_by!(permalink: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def paste_params
    params.require(:paste).permit(:body, :language, :auto_destroy, :ttl_days) if params[:paste].present?
  end
end
