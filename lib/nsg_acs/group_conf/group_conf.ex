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

  def list_group_names(first) do
    list = Repo.all(from(g in Group, order_by: g.name, select: g.name))
    (first in list && [first | list |> Enum.reject(fn x -> x == first end)]) || list
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

  def get_group_by_name(name), do: Repo.get_by(Group, name: name)

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

  @templ_regex ~r/\$\((\w[\w\d_]*)=?([^\)]*)\)/
  def key_params_list do
    ["GROUP", "ID", "SN", "SN_LB", "SN_HB"]
  end

  def get_all_params_from_template(tp) do
    @templ_regex
    |> Regex.scan(tp)
    |> Enum.group_by(fn [_, x, _] -> x end, fn [_, _, x] -> x end)
    |> Enum.map(fn {k, v} -> {k, extract_defaults(v)} end)
    |> Enum.into(%{})
  end

  def get_params_from_template(tp) do
    tp
    |> get_all_params_from_template
    |> Map.drop(key_params_list())
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

  def get_conf_from_template(device) do
    params = device.params
    tp = device.group.template
    templ_params = get_params_from_template(tp)
    key_params = get_params_from_key(device)
    params = Map.merge(params, key_params)

    @templ_regex
    |> Regex.replace(tp, fn _, match ->
      params[match] || (templ_params[match] && templ_params[match] |> Enum.at(0)) || ""
    end)
  end

  @key_regex ~r/(.*)_\d*(\d\d\d\d\d\d)$/

  def get_params_from_key(device) do
    case Regex.run(@key_regex, device.key) do
      [id, _model, zsn] ->
        sn = String.to_integer(zsn)

        %{
          "GROUP" => device.group.name,
          "ID" => id,
          "SN" => zsn,
          "SN_LB" => Integer.to_string(rem(sn, 256)),
          "SN_HB" => Integer.to_string(div(sn, 256))
        }

      _ ->
        %{
          "GROUP" => device.group.name
        }
    end
  end
end
