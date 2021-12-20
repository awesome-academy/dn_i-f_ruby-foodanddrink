class Ability
  include CanCan::Ability

  def initialize user
    can %i(home read), Product

    return if user.blank?

    if user.user?
      can :manage, User, id: user.id
      can %i(create show update), Order, user_id: user.id
    end
    can :manage, :all if user.admin?
  end
end
