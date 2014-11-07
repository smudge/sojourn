require_relative 'visitor'
require_relative 'visit'
module Sojourn
  class VisitTracker

    def initialize(request, session, current_user = nil, now = Time.now)
      self.request, self.session, self.current_user, @now = request, session, current_user, now
    end

    def current_visit
      @current_visit ||= Visit.find_by_uuid(session[:sojourner_visit_uuid])
    end

    def current_visitor
      @current_visitor ||= Visitor.find_by_uuid(session[:sojourner_visitor_uuid])
    end

    def track!(time = Time.now)
      return if bot?
      track_visitor!(time) if should_track_visitor?
      track_visit!(time) if should_track_visit?
      mark_active!(time)
    end

    def track_visitor!(time = Time.now)
      if unknown_visitor? || (user_changed? && !user_added?)
        @current_visitor = Visitor.create_from_request!(request, current_user, time)
        session[:sojourner_visitor_uuid] = @current_visitor.uuid
        session[:sojourner_current_user_id] = current_user.try(:id)
        session[:sojourner_visit_uuid] = nil
        session[:sojourner_last_active_at] = nil
      else
        session[:sojourner_current_user_id] = current_user.try(:id)
        current_visitor.update_attributes(user_id: current_user.try(:id))
      end
    end

    def track_visit!(time = Time.now)
      @current_visit = Visit.create_from_request!(request, current_visitor, time)
      session[:sojourner_visit_uuid] = @current_visit.uuid
    end

    def mark_active!(time = Time.now)
      session[:sojourner_last_active_at] = time
    end

  private

    attr_accessor :request, :session, :current_user

    # Browser & Bot Detection

    def browser
      @browser ||= Browser.new(user_agent: @request.user_agent)
    end

    def bot?
      browser.bot?
    end

    # Visitor Tracking Policy

    def should_track_visitor?
      unknown_visitor? || expired_visitor? || user_changed?
    end

    def unknown_visitor?
      session[:sojourner_visitor_uuid].blank?
    end

    def expired_visitor?
      session[:sojourner_last_active_at] < @now - 1.week
    end

    def user_changed?
      current_user.try(:id) != session[:sojourner_current_user_id]
    end

    def user_added?
      session[:sojourner_current_user_id].blank? && session[:sojourner_visitor_uuid]
    end

    # Visit Tracking Policy

    def should_track_visit?
      unknown_visit? || expired_visit? || new_visit_required?
    end

    def unknown_visit?
      session[:sojourner_visit_uuid].blank?
    end

    def expired_visit?
      session[:sojourner_last_active_at] < @now - 1.day
    end

    def new_visit_required?
      outside_referer? || any_utm_data?
    end

    def outside_referer?
      request.referer.present? && URI.parse(request.referer).host != request.host
    end

    def any_utm_data?
      Sojourn.config.campaign_params.map { |p| request.params[p].present? }.any?
    end
  end
end
