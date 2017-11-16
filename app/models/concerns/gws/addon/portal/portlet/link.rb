module Gws::Addon::Portal::Portlet
  module Link
    extend ActiveSupport::Concern
    extend SS::Addon

    set_addon_type :portlet

    included do
      field :links, type: Array, default: []
      permit_params links: [:name, :url]

      validate :validate_links, if: ->{ portlet_model == 'links' }
    end

    private

    def validate_links
      items = links.to_a.select do |item|
        item.values.join.present?
      end
      self.links = items
    end
  end
end
