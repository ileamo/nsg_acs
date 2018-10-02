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

  @doc """
  Creates a newdev.

  ## Examples

      iex> create_newdev(%{field: value})
      {:ok, %Newdev{}}

      iex> create_newdev(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_newdev(attrs \\ %{}) do
    %Newdev{}
    |> Newdev.changeset(attrs)
    |> Repo.insert()
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
