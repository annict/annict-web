# frozen_string_literal: true

class CharactersController < ApplicationV6Controller
  def show
    @character = Character.only_kept.find(params[:character_id])
    @casts_with_year = @character
      .casts
      .only_kept
      .preload(:person, anime: :anime_image)
      .joins(:anime)
      .where(works: {deleted_at: nil})
      .group_by { |cast| cast.anime.season_year.presence || 0 }
    @cast_years = @casts_with_year.keys.sort.reverse

    @character_favorites = @character
      .character_favorites
      .eager_load(user: :profile)
      .merge(User.only_kept)
      .order(id: :desc)
  end
end
