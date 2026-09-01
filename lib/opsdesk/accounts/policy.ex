defmodule Opsdesk.Accounts.Policy do
  @moduledoc """
  Central authorization rules. `can?/2` answers whether a user may perform
  an action. Rules are evaluated top-down; anything not explicitly allowed
  is denied.
  """

  alias Opsdesk.Accounts.User

  @spec can?(User.t() | nil, atom()) :: boolean()

  # Admins may do everything.
  def can?(%User{role: :admin}, _action), do: true

  # Financial visibility.
  def can?(%User{role: role}, :view_financials)
      when role in [:ceo, :finance, :management],
      do: true

  # Anything any authenticated user may do.
  def can?(%User{}, action)
      when action in [:view_own_assets, :raise_request],
      do: true

  # Default deny — must stay last.
  def can?(_user, _action), do: false
end
