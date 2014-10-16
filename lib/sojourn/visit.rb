module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  class Visit < ActiveRecord::Base

    belongs_to :visitor, foreign_key: :sojourn_visitor_id
    has_one :user, through: :visitor

    scope :unexpired, -> { where('last_active_at > ?', 1.day.ago) }

    before_create { self.uuid = SecureRandom.uuid }

    class << self

      def find_from_request(request, visitor)
        visitor.visits.unexpired.last unless new_visit_required?(request)
      end

      def create_from_request!(request, visitor)
        create! referrer: request.referer,
                host: request.host,
                path: request.path,
                utm_source: request.params[:utm_source],
                utm_medium: request.params[:utm_medium],
                utm_term: request.params[:utm_term],
                utm_content: request.params[:utm_content],
                utm_campaign: request.params[:utm_campaign],
                visitor: visitor
      end

    private

      def new_visit_required?(request)
        outside_referer?(request) || any_utm_data?(request)
      end

      def outside_referer?(request)
        request.referer.present? && URI.parse(request.referer).host != request.host
      end

      def any_utm_data?(request)
        request.params[:utm_source].present?  ||
        request.params[:utm_medium].present?  ||
        request.params[:utm_term].present?    ||
        request.params[:utm_content].present? ||
        request.params[:utm_campaign].present?
      end

    end

  end
end
