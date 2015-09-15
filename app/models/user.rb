class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :personality
  has_one :token

  has_one :schedule
  has_many :tasks
  has_many :alarms

  before_create :build_default_personality

  def build_default_personality
    self.build_personality
  end
end
