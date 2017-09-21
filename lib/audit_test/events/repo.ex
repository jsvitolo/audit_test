defmodule AuditTest.Events.Repo do
  defmacro __using__(opts) do
    quote do

      def audited_insert(user_id, opts \\ []) do
        AuditTest.Events.Repo.Schema.audited_insert(__MODULE__, user_id, opts)
      end

      def audited_update(changeset, user_id, opts \\ []) do
        AuditTest.Events.Repo.Schema.audited_update(__MODULE__, changeset, user_id, opts)
      end
    end
  end
end
