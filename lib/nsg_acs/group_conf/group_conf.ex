defmodule NsgAcs.GroupConf do
  @moduledoc """
  The GroupConf context.
  """

  import Ecto.Query, warn: false
  alias NsgAcs.Repo

  alias NsgAcs.GroupConf.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  def get_params_from_template(tp) do
    ~r/\$\((\w[\w\d_]*)=?([^\)]*)\)/
    |> Regex.scan(tp)
    |> Enum.group_by(fn [_, x, _] -> x end, fn [_, _, x] -> x end)
    |> Enum.map(fn {k, v} -> {k, extract_defaults(v)} end)
    |> Enum.into(%{})
  end

  defp extract_defaults(v) do
    Enum.max_by(v, &num_of_delimiter/1)
    |> String.split("|", trim: true)
  end

  defp num_of_delimiter(str) do
    (str == "" && -1) ||
      Regex.scan(~r/\|/, str)
      |> Enum.count()
  end
end
