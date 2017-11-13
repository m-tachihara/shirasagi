class Gws::Schedule::TodoManagementController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  helper Gws::Schedule::PlanHelper
  model Gws::Schedule::Todo

  before_action :set_item, only: [:show, :edit, :update, :delete, :destroy, :active]
  before_action :set_selected_items, only: :active_all

  private

  def set_crumbs
    @crumbs << [t('modules.gws/schedule'), gws_schedule_main_path]
    @crumbs << [t('modules.addons.gws/schedule/todo'), gws_schedule_todos_path]
    @crumbs << ['管理', gws_schedule_todo_management_index_path]
  end

  public

  def index
    @items = @model.site(@cur_site).
      allow(:read, @cur_user, site: @cur_site).deleted.
      search(params[:s]).order_by(deleted: -1).page(params[:page]).per(50)
  end

  def active
    raise '403' unless @item.allowed?(:edit, @cur_user, site: @cur_site)
    render_destroy @item.active
  end

  def active_all
    entries = @items.entries
    @items = []

    entries.each do |item|
      if item.allowed?(:edit, @cur_user, site: @cur_site)
        next if item.active
      else
        item.errors.add :base, :auth_error
      end
      @items << item
    end
    render_destroy_all(entries.size != @items.size)
  end
end
