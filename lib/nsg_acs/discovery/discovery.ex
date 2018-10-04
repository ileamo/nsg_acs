defmodule NsgAcs.Discovery do
  @moduledoc """
  The Discovery context.
  """

  import Ecto.Query, warn: false
  alias NsgAcs.Repo

  alias NsgAcs.Discovery.Newdev

  @doc """
  Returns the list of newdevs.

  ## Examples

      iex> list_newdevs()
      [%Newdev{}, ...]

  """
  def list_newdevs do
    Repo.all(Newdev)
  end

  @doc """
  Gets a single newdev.

  Raises `Ecto.NoResultsError` if the Newdev does not exist.

  ## Examples

      iex> get_newdev!(123)
      %Newdev{}

      iex> get_newdev!(456)
      ** (Ecto.NoResultsError)

  """
  def get_newdev!(id), do: Repo.get!(Newdev, id)

  def insert_or_update_newdev(attrs = %{key: key}) do
    case Newdev |> Repo.get_by(key: key) do
      nil -> %Newdev{}
      newdev -> newdev
    end
    |> Newdev.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Updates a newdev.

  ## Examples

      iex> update_newdev(newdev, %{field: new_value})
      {:ok, %Newdev{}}

      iex> update_newdev(newdev, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_newdev(%Newdev{} = newdev, attrs) do
    newdev
    |> Newdev.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Newdev.

  ## Examples

      iex> delete_newdev(newdev)
      {:ok, %Newdev{}}

      iex> delete_newdev(newdev)
      {:error, %Ecto.Changeset{}}

  """
  def delete_newdev(%Newdev{} = newdev) do
    Repo.delete(newdev)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking newdev changes.

  ## Examples

      iex> change_newdev(newdev)
      %Ecto.Changeset{source: %Newdev{}}

  """
  def change_newdev(%Newdev{} = newdev) do
    Newdev.changeset(newdev, %{})
  end
end
