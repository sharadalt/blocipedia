class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :wikis, :dependent => :destroy
  enum role: [:admin, :standard, :premium]
  before_save { self.role ||= :standard }
 
end
