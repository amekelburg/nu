class ExperimentRealizationsController < ApplicationController

  before_filter :require_login
  before_filter :load_experiment

  # creates new realization for the experiment
  def create
    description = DeterLab.realize_experiment(current_user_id, @experiment.id, "#{current_user_id}:#{current_user_id}")

    ActivityLog.for_experiment(@experiment.id).add("realized", current_user_id)

    show(description.first)
  end

  # realization info page
  def show(description = nil)

    description ||= DeterLab.view_realizations(current_user_id, regex: "^#{params[:id]}$").first

    respond_to do |format|
      format.html do
        @visualizations = @experiment.aspects.select do |a|
          a.type == 'visualization' && a.sub_type.blank?
        end
        gon.description  = description
        gon.user_name    = "#{current_user_id} (#{current_user_name})"
        gon.refresh_rate = AppConfig['realization_refresh_rate'] * 1000
        gon.view_url     = experiment_realization_path(@experiment.id, description.name)
        render :show
      end

      format.js do
        render json: description
      end
    end
  end

  # releases realization resources
  def release
    realization_name = params[:id]
    DeterLab.release_realization(current_user_id, realization_name)
    redirect_to experiment_path(params[:experiment_id])
  rescue DeterLab::AccessDenied
    redirect_to experiment_path(params[:experiment_id]), alert: 'Access denied'
  end

  # deletes realization
  def destroy
    realization_name = params[:id]
    DeterLab.remove_realization(current_user_id, realization_name)
    redirect_to experiment_path(params[:experiment_id])
  rescue DeterLab::AccessDenied
    redirect_to experiment_path(params[:experiment_id]), alert: 'Access denied'
  end

  private

  def load_experiment
    @experiment = deter_lab.get_experiment(params[:experiment_id])
  end

end
