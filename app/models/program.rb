# frozen_string_literal: true
# == Schema Information
#
# Table name: programs
#
#  id             :integer          not null, primary key
#  channel_id     :integer          not null
#  episode_id     :integer          not null
#  work_id        :integer          not null
#  started_at     :datetime         not null
#  sc_last_update :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  sc_pid         :integer
#  rebroadcast    :boolean          default(FALSE), not null
#
# Indexes
#
#  index_programs_on_sc_pid  (sc_pid) UNIQUE
#  programs_channel_id_idx   (channel_id)
#  programs_episode_id_idx   (episode_id)
#  programs_work_id_idx      (work_id)
#

class Program < ActiveRecord::Base
  include DbActivityMethods

  DIFF_FIELDS = %i(channel_id episode_id started_at rebroadcast).freeze

  attr_accessor :time_zone

  belongs_to :channel
  belongs_to :episode
  belongs_to :work, touch: true
  has_many :db_activities, as: :trackable, dependent: :destroy
  has_many :db_comments, as: :resource, dependent: :destroy

  validates :channel_id, presence: true
  validates :episode_id, presence: true
  validates :started_at, presence: true

  scope :episode_published, -> { joins(:episode).merge(Episode.published) }
  scope :work_published, -> { joins(:work).merge(Work.published) }

  before_save :calc_for_timezone

  def broadcasted?(time = Time.now.in_time_zone("Asia/Tokyo"))
    time > started_at.in_time_zone("Asia/Tokyo")
  end

  def calc_for_timezone
    started_at = ActiveSupport::TimeZone.new(time_zone).local_to_utc(self.started_at)
    self.started_at = started_at
    self.sc_last_update = Time.zone.now
  end

  def to_diffable_hash
    data = self.class::DIFF_FIELDS.each_with_object({}) do |field, hash|
      hash[field] = send(field)
      hash
    end

    data.delete_if { |_, v| v.blank? }
  end
end
