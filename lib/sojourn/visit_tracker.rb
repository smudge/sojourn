require_relative 'visitor'
require_relative 'visit'
module Sojourn
  class VisitTracker

    def initialize(request, session, current_user = nil, now = Time.now)
      self.request, self.session, self.current_user, @now = request, session, current_user, now
    end

    def current_visit
      @current_visit ||= Visit.find_by_uuid(session[:sojourn_visit_uuid])
    end

    def current_visitor
      @current_visitor ||= Visitor.find_by_uuid(session[:sojourn_visitor_uuid])
    end

    def track!(time = Time.now)
      return if bot?
      track_visitor!(time) if should_track_visitor?
      if should_track_visit?
        track_visit!(time)
      elsif user_added?
        track_user_change!
      end
      mark_active!(time)
    end

    def track_visitor!(time = Time.now)
      @current_visitor = Visitor.create_from_request!(request, time)
      session[:sojourn_visitor_uuid] = @current_visitor.uuid
      session[:sojourn_visit_uuid] = nil
      session[:sojourn_last_active_at] = nil
    end

    def track_visit!(time = Time.now)
      @current_visit = Visit.create_from_request!(request, current_visitor, current_user, time)
      session[:sojourn_visit_uuid] = @current_visit.uuid
      session[:sojourn_current_user_id] = current_user.try(:id)
    end

    def track_user_change!
      current_visit.update_attributes(user_id: current_user.try(:id))
      session[:sojourn_current_user_id] = current_user.try(:id)
    end

    def mark_active!(time = Time.now)
      session[:sojourn_last_active_at] = time
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
      unknown_visitor? || expired_visitor?
    end

    def unknown_visitor?
      session[:sojourn_visitor_uuid].blank?
    end

    def expired_visitor?
      return unless Sojourn.config.visitor_expires_after
      session[:sojourn_last_active_at] < @now - Sojourn.config.visitor_expires_after
    end

    # Visit Tracking Policy

    def should_track_visit?
      unknown_visit? || expired_visit? || logged_out? || new_visit_required?
    end

    def unknown_visit?
      session[:sojourn_visit_uuid].blank?
    end

    def expired_visit?
      return unless Sojourn.config.visit_expires_after
      session[:sojourn_last_active_at] < @now - Sojourn.config.visit_expires_after
    end

    def logged_out?
      user_changed? && !user_added?
    end

    def user_changed?
      current_user.try(:id) != session[:sojourn_current_user_id]
    end

    def user_added?
      current_user && session[:sojourn_current_user_id].blank?
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
