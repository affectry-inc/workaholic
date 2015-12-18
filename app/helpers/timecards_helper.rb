module TimecardsHelper
  def approver_of?(user_id)
    Approver.where(user_id: user_id).where(approver_user_id: current_user.id).count > 0
  end
end
