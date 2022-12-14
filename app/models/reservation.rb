class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  with_options presence: true do
    validates :check_in
    validates :check_out
    validates :total_gests
  end

  validate :today_before_check_in
  validate :check_in_before_check_out
  validate :min_total_gests

  def today_before_check_in
    return if check_in.blank?
    if check_in < Date.today
      errors.add :check_in, "は本日以降を選択して下さい"
    end
  end
  
  def check_in_before_check_out
    return if check_in.blank? || check_out.blank?
    if check_in == check_out || check_out < check_in 
      errors.add :check_out, "は宿泊当日日以降を選択して下さい"
    end
  end

  def min_total_gests
    return if total_gests.blank?
    if total_gests.to_i <= 0
      errors.add :total_gests,"は一名様以上でお願いします"
    end
  end

  def total_days
    (check_out - check_in).to_i
  end

  def total_price
    total_days * total_gests * room.price
  end

end
