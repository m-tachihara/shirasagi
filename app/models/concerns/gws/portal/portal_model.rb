module Gws::Portal::PortalModel
  extend ActiveSupport::Concern
  extend SS::Translation

  included do
    attr_accessor :portal_type
  end

  def my_portal?
    portal_type == :my_portal
  end

  def user_portal?
    portal_type == :user_portal
  end

  def group_portal?
    portal_type == :group_portal
  end

  def root_portal?
    portal_type == :root_portal
  end

  def portal_readable?(user, opts = {})
    return true if allowed?(:read, user, site: opts[:site] || site, strict: true)
    return true if readable?(user, opts[:site] || site)
    false
  end

  def save_default_portlets
    default_portlets.each do |item|
      user_ids = [@cur_user.id]
      user_ids << portal_user_id if try(:portal_user_id)

      item.cur_user   = @cur_user
      item.cur_site   = @cur_site
      item.setting_id = id
      item.user_ids   = user_ids

      if !item.save
        Rails.logger.warn("#{__FILE__}:#{__LINE__} - " + item.errors.full_messages.join(' '))
      end
    end
  end
end
