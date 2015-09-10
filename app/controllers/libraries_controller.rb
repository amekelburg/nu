class LibrariesController < ApplicationController

  before_filter :require_login

  # lists user-accessible libraries
  def index
    uid = current_user_id
    @libraries = get_libraries.sort do |l1, l2|
      o1 = l1[:owner][:uid] == uid
      o2 = l2[:owner][:uid] == uid
      if o1 == Library::MAIN_LIBRARY_ID
        -1
      elsif o2 == Library::MAIN_LIBRARY_ID
        1
      elsif o1 == o2
        l1[:library_id] <=> l2[:library_id]
      elsif o1
        -1
      else
        1
      end
    end
  end

  # shows the library
  def show
    lid = params[:id]
    @library = load_library(lid)
    if @library.nil?
      redirect_to :dashboard, alert: t(".not_found")
      return
    end

    @project_experiments = get_project_experiments

    gon.libraryDetailsUrl = details_library_path(lid)

    render :show
  end

  # managing the library
  def manage
    deter_lab.invalidate_experiments
    show
  end

  # renders details about library experiments
  # called by JS from the library/show page
  def details
    lid = params[:id]
    @experiments = get_library_experiments_details(lid)
    render json: {
      experiments_html: render_to_string(partial: "shared/details_experiments")
    }
  end

  # shows new library form
  def new
    @profile_descr = deter_lab.get_library_profile_description
    render :new
  end

  # creates the library
  def create
    name = lp.delete(:name)
    lid = "#{current_user_id}:#{name}"
    if DeterLab.create_library(current_user_id, lid, lp)
      deter_lab.invalidate_libraries
      redirect_to :libraries, notice: t(".success")
    else
      flash.now.alert = t(".failure", error: t("libraries.errors.unknown"))
      new
    end
  end

  # copies an experiment to this library
  def copy_experiment
    lid = params[:id]
    @library = load_library(lid)
    if @library.nil?
      redirect_to :dashboard, alert: t(".not_found")
      return
    end

    do_copy_experiment(@library, params[:experiment_id])
    deter_lab.invalidate_experiments

    redirect_to manage_library_path(@library.id), notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to manage_library_path(@library.id), alert: t(".failure", error: e.message)
  end

  private

  def get_library_experiments_details(lid)
    SummaryLoader.library_experiments(deter_cache, current_user_id, lid).map do |e|
      { id:     e.id,
        owner:  { id: e.owner, name: user_name(e.owner) },
        descr:  deter_lab.get_experiment_profile(e.id)['description'].try(:value),
        status: 'TBD'
      }
    end
  end

  def get_libraries
    SummaryLoader.user_libraries(current_user_id)
  end

  def lp
    params[:library]
  end

  def get_project_experiments
    deter_lab.get_experiments.select { |ex| ex.id =~ /^[A-Z]/ }
  end

  def load_library(eid)
    deter_lab.view_libraries.find { |l| l.id == eid }
  end

  def do_copy_experiment(library, experiment_id)
    DeterLab.add_library_experiments(current_user_id, library.id, [ experiment_id ])
  end

end
