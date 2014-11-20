require_relative 'visitor'
require_relative 'visit'
require_relative 'event'

module Sojourn
  class Tracker

    def initialize(request, session, current_user = nil)
      self.request, self.session, self.current_user, @now =
        Request.from_request(request), session, current_user, Time.now
    end

    def current_visit
      @current_visit ||= Visit.find_by_uuid(session[:sojourn_visit_uuid])
    end

    def current_visitor
      @current_visitor ||= Visitor.find_by_uuid(session[:sojourn_visitor_uuid])
    end

    def track!(event_name, properties = {}, user_id = current_user.try(:id))
      Event.create! name: event_name, request: request, visit: current_visit,
                    properties: properties, created_at: Time.now, user_id: user_id
    end

    def track_request!
      return if request.bot?
      track_visitor! if should_track_visitor?
      if should_track_visit?
        track_visit!
      elsif user_added?
        track_user_change!
      end
      mark_active!
    end

    def track_visitor!
      @current_visitor = Visitor.create!
      session[:sojourn_visitor_uuid] = @current_visitor.uuid
      session[:sojourn_visit_uuid] = nil
      session[:sojourn_last_active_at] = nil
    end

    def track_visit!
      @current_visit = current_visitor.visits.create!(request: request, user: current_user)
      session[:sojourn_visit_uuid] = @current_visit.uuid
      session[:sojourn_current_user_id] = current_user.try(:id)
    end

    def track_user_change!
      track!('!logged_out', {}, session[:sojourn_current_user_id]) if session[:sojourn_current_user_id]
      track!('!logged_in', {}, current_user.id) if current_user
      session[:sojourn_current_user_id] = current_user.try(:id)
    end

    def mark_active!
      session[:sojourn_last_active_at] = @now
    end

  private

    attr_accessor :request, :session, :current_user

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
      request.outside_referer? || request.any_utm_data?
    end
  end
end
