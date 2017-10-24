class Gws::Portal::Group::PortletsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Portal::PortalFilter

  model Gws::Portal::GroupPortlet

  navi_view 'gws/portal/group/navi'

  before_action :set_portal_setting
  before_action :save_portal_setting

  private

  def set_crumbs
    if @cur_site.id.to_s == params[:group].to_s
      @crumbs << [t("gws/portal.root_portal"), gws_portal_group_path]
    else
      @crumbs << [t("gws/portal.group_portal"), gws_portal_group_path]
    end
    @crumbs << [t("gws/portal.links.manage_portlets"), action: :index]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, setting_id: @portal.try(:id) }
  end

  public

  def index
    @items = @portal.portlets.
      search(params[:s])
  end

  def new
    new_portlet
  end
end