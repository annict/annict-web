# frozen_string_literal: true

module Db
  class CharacterRowsFormPolicy < ApplicationPolicy
    def create?
      user.committer?
    end

    def update?
      user.committer?
    end
  end
end
