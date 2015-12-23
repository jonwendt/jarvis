class PersonalitiesController < ApplicationController
  before_action :set_personality, only: [:assign_to_user, :show, :edit, :update, :destroy]

  def assign_to_user
    @personality = Personality.find(params[:id])
    current_user.personality = @personality

    respond_to do |format|
      if current_user.save
        format.html { redirect_to root_url, notice: "My personality is now set to #{@personality.name}." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /personalities
  # GET /personalities.json
  def index
    @personalities = Personality.all
  end

  # GET /personalities/1
  # GET /personalities/1.json
  def show
  end

  # GET /personalities/new
  def new
    @personality = Personality.new
  end

  # GET /personalities/1/edit
  def edit
  end

  # POST /personalities
  # POST /personalities.json
  def create
    @personality = Personality.new(personality_params)

    respond_to do |format|
      if @personality.save
        format.html { redirect_to root_url, notice: 'Personality was successfully created.' }
        format.json { render :show, status: :created, location: @personality }
      else
        format.html { render :new }
        format.json { render json: @personality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personalities/1
  # PATCH/PUT /personalities/1.json
  def update
    respond_to do |format|
      if @personality.update(personality_params)
        format.html { redirect_to root_url, notice: 'Personality was successfully updated.' }
        format.json { render :show, status: :ok, location: @personality }
      else
        format.html { render :edit }
        format.json { render json: @personality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personalities/1
  # DELETE /personalities/1.json
  def destroy
    @personality.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Personality was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personality
      @personality = Personality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personality_params
      params[:personality].permit(:name, :moods_list, :user_id)
    end
end