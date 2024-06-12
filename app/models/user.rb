class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  before_save :set_goal_value_based_on_goal_and_mobility
  
  validates :name, :age, :weight, :gender, :height, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, numericality: { greater_than: 0 }
  validates :gender, inclusion: { in: %w[male female] }

  GOAL_VALUES = {
    'похудение' => [26, 27, 27, 28, 29],
    'поддержание' => [30, 31, 32, 33, 35],
    'набор' => [40, 41, 42, 43, 45]
  }

  GOALS = GOAL_VALUES.keys

  def set_goal_value_based_on_goal_and_mobility
    return unless goal.present? && mobility.present?

    self.goal_value = GOAL_VALUES[goal][mobility - 1]
  end  
end
