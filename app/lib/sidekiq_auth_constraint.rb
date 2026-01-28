
class SidekiqAuthConstraint
  def matches?(request)
    # Get the user from the Devise session
    user = request.env["warden"].user(:user)

    # Check if user exists and run Pundit-style logic
    # You can call a Policy directly here:
    user.present? && SidekiqDashboardPolicy.new(user, :dashboard).show?
  end
end
