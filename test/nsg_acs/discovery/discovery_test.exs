defmodule NsgAcs.DiscoveryTest do
  use NsgAcs.DataCase

  alias NsgAcs.Discovery

  describe "newdevs" do
    alias NsgAcs.Discovery.Newdev

    @valid_attrs %{from: "some from", group: "some group", key: "some key", source: "some source"}
    @update_attrs %{from: "some updated from", group: "some updated group", key: "some updated key", source: "some updated source"}
    @invalid_attrs %{from: nil, group: nil, key: nil, source: nil}

    def newdev_fixture(attrs \\ %{}) do
      {:ok, newdev} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discovery.create_newdev()

      newdev
    end

    test "list_newdevs/0 returns all newdevs" do
      newdev = newdev_fixture()
      assert Discovery.list_newdevs() == [newdev]
    end

    test "get_newdev!/1 returns the newdev with given id" do
      newdev = newdev_fixture()
      assert Discovery.get_newdev!(newdev.id) == newdev
    end

    test "create_newdev/1 with valid data creates a newdev" do
      assert {:ok, %Newdev{} = newdev} = Discovery.create_newdev(@valid_attrs)
      assert newdev.from == "some from"
      assert newdev.group == "some group"
      assert newdev.key == "some key"
      assert newdev.source == "some source"
    end

    test "create_newdev/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discovery.create_newdev(@invalid_attrs)
    end

    test "update_newdev/2 with valid data updates the newdev" do
      newdev = newdev_fixture()
      assert {:ok, newdev} = Discovery.update_newdev(newdev, @update_attrs)
      assert %Newdev{} = newdev
      assert newdev.from == "some updated from"
      assert newdev.group == "some updated group"
      assert newdev.key == "some updated key"
      assert newdev.source == "some updated source"
    end

    test "update_newdev/2 with invalid data returns error changeset" do
      newdev = newdev_fixture()
      assert {:error, %Ecto.Changeset{}} = Discovery.update_newdev(newdev, @invalid_attrs)
      assert newdev == Discovery.get_newdev!(newdev.id)
    end

    test "delete_newdev/1 deletes the newdev" do
      newdev = newdev_fixture()
      assert {:ok, %Newdev{}} = Discovery.delete_newdev(newdev)
      assert_raise Ecto.NoResultsError, fn -> Discovery.get_newdev!(newdev.id) end
    end

    test "change_newdev/1 returns a newdev changeset" do
      newdev = newdev_fixture()
      assert %Ecto.Changeset{} = Discovery.change_newdev(newdev)
    end
  end
end
