defmodule Opsdesk.Accounts.PolicyTest do
  use ExUnit.Case, async: true

  alias Opsdesk.Accounts.Policy
  alias Opsdesk.Accounts.User

  defp user(role), do: %User{role: role}

  describe "can?/2 for admins" do
    test "admins may perform any action" do
      admin = user(:admin)

      assert Policy.can?(admin, :view_financials)
      assert Policy.can?(admin, :view_own_assets)
      assert Policy.can?(admin, :raise_request)
      assert Policy.can?(admin, :some_action_invented_later)
    end
  end

  describe "can?/2 for :view_financials" do
    test "is allowed for ceo, finance and management" do
      for role <- [:ceo, :finance, :management] do
        assert Policy.can?(user(role), :view_financials),
               "expected #{role} to be allowed :view_financials"
      end
    end

    test "is denied for employee and hr" do
      for role <- [:employee, :hr] do
        refute Policy.can?(user(role), :view_financials),
               "expected #{role} to be denied :view_financials"
      end
    end
  end

  describe "can?/2 for baseline authenticated actions" do
    test "every role may view their own assets and raise requests" do
      for role <- [:employee, :admin, :hr, :finance, :ceo, :management] do
        assert Policy.can?(user(role), :view_own_assets)
        assert Policy.can?(user(role), :raise_request)
      end
    end
  end

  describe "can?/2 default deny" do
    test "denies an action with no matching rule" do
      for role <- [:employee, :hr, :finance, :ceo, :management] do
        refute Policy.can?(user(role), :retire_asset)
        refute Policy.can?(user(role), :unknown_action)
      end
    end

    test "denies everything for a nil user" do
      refute Policy.can?(nil, :view_financials)
      refute Policy.can?(nil, :view_own_assets)
      refute Policy.can?(nil, :raise_request)
    end
  end
end
