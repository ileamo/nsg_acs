defmodule NsgAcs.GroupConfTest do
  use NsgAcs.DataCase

  alias NsgAcs.GroupConf

  describe "groups" do
    alias NsgAcs.GroupConf.Group

    @valid_attrs %{name: "some name", template: "some template"}
    @update_attrs %{name: "some updated name", template: "some updated template"}
    @invalid_attrs %{name: nil, template: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> GroupConf.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert GroupConf.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert GroupConf.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = GroupConf.create_group(@valid_attrs)
      assert group.name == "some name"
      assert group.template == "some template"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GroupConf.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = GroupConf.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.name == "some updated name"
      assert group.template == "some updated template"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = GroupConf.update_group(group, @invalid_attrs)
      assert group == GroupConf.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = GroupConf.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> GroupConf.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = GroupConf.change_group(group)
    end
  end
end
