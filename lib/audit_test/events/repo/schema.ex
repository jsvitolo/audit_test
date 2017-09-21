defmodule AuditTest.Events.Repo.Schema do
  alias Ecto.Multi

  def audited_insert(repo, user_id, opts \\ []) do
    begin_transaction
  end

  def audited_update(repo, changeset, user_id, opts \\ []) do
    begin_transaction
    |> save_changeset(changeset, :update)
    |> audit_changes(repo, changeset, user_id)
    |> commit_transaction(repo)
  end

  defp begin_transaction do
    Multi.new
  end

  defp save_changeset(multi, changeset, :insert) do
    multi
    |> Multi.insert(:save, changeset)
  end

  defp save_changeset(multi, changeset, :update) do
    multi
    |> Multi.update(:save, changeset)
  end

  defp audit_changes(multi, repo, changeset, user_id) do
    multi
    |> Multi.run(:audit, fn result ->
      case result do
        %{save: struct} ->
          insert_audit(repo, struct, changeset, user_id)
        otherwise ->
          otherwise
      end
    end)
  end


  defp commit_transaction(multi, repo) do
    multi
    |> repo.transaction
    |> case do
         {:ok, %{save: record}} ->
           {:ok, record}
         otherwise ->
           otherwise
       end
  end

  defp insert_audit(repo, struct, changeset, user_id) do
    event_module = changeset |> event_module
    event_struct = event_module |> struct

    event_struct
    |> event_module.changeset(%{
          "committed_at" => DateTime.utc_now,
          "committed_by" => user_id,
          "changes" => changeset.changes,
          "#{changeset |> schema_key}_id" => struct.id
    })
    |> repo.insert
    |> case  do
         {:ok, _} -> {:ok, struct}
         otherwise -> otherwise
       end
  end

  defp schema_key(changeset) do
    changeset
    |> schema_module
    |> Macro.underscore
    |> String.split("/")
    |> List.last
  end

  defp schema_module(changeset) do
    "Elixir." <> struct_name = Atom.to_string(changeset.data.__struct__)
    struct_name
  end

  defp event_module(changeset) do
    Module.concat(["#{changeset |> schema_module}Event"])
  end
end
