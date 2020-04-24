# frozen_string_literal: true

module V4
  class WorksController < V4::ApplicationController
    def show
      @work = Work.only_kept.find(params[:id])
    end
  end
end