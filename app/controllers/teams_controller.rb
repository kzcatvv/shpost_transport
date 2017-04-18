class TeamsController < ApplicationController
  load_and_authorize_resource :team
  # before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams_grid = initialize_grid(@teams)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: I18n.t('controller.create_success_notice', model: '车队')}
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: I18n.t('controller.update_success_notice', model: '车队') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :no, :leader_id)
    end
end
