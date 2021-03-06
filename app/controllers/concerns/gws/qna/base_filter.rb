module Gws::Qna::BaseFilter
  extend ActiveSupport::Concern

  included do
    before_action :set_mode
    before_action :set_category
    before_action :set_parent
    before_action :set_crumbs
  end

  private

  def set_mode
    @mode = %w(editable).include?(params[:mode]) ? params[:mode] : 'readable'
  end

  def set_category
    @categories = Gws::Qna::Category.site(@cur_site).readable(@cur_user, site: @cur_site).tree_sort

    if category_id = params[:category].presence
      @category ||= Gws::Qna::Category.site(@cur_site).readable(@cur_user, site: @cur_site).where(id: category_id).first
    end
  end

  def set_parent
    @topic  = @model.find params[:topic_id] if params[:topic_id].present?
    @parent = @model.find params[:parent_id] if params[:parent_id].present?
  end

  def set_crumbs
    @crumbs << [@cur_site.menu_question_label || t("modules.gws/qna"), gws_qna_topics_path(mode: '-', category: '-')]
    @crumbs << [t("ss.navi.#{@mode}"), gws_qna_topics_path(category: '-')]
    @crumbs << [@category.name, gws_qna_topics_path] if @category.present?
  end
end
