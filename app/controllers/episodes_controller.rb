# frozen_string_literal: true

class EpisodesController < ApplicationV6Controller
  include EpisodeRecordListSettable

  def index
    set_page_category PageCategory::EPISODE_LIST

    @anime = Anime.only_kept.find(params[:anime_id])
    raise ActionController::RoutingError, "Not Found" if @anime.no_episodes?

    @programs = @anime.programs.eager_load(:channel).only_kept.in_vod.merge(Channel.order(:sort_number))
    @episodes = @anime.episodes.only_kept.order(:sort_number).page(params[:page]).per(100).without_count
    @anime_ids = [@anime.id]
end

  def show
    set_page_category PageCategory::EPISODE

    @anime = Anime.only_kept.find(params[:anime_id])
    @episode = @anime.episodes.only_kept.find(params[:episode_id])
    @vod_channels = Channel.only_kept.joins(:programs).merge(@anime.programs.only_kept.in_vod).order(:sort_number)
    @form = ::Forms::EpisodeRecordForm.new(episode: @episode)

    set_episode_record_list(@episode)
  end
end
