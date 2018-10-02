defmodule NsgAcsWeb.NewdevControllerTest do
  use NsgAcsWeb.ConnCase

  alias NsgAcs.Discovery

  @create_attrs %{from: "some from", group: "some group", key: "some key", source: "some source"}
  @update_attrs %{from: "some updated from", group: "some updated group", key: "some updated key", source: "some updated source"}
  @invalid_attrs %{from: nil, group: nil, key: nil, source: nil}

  def fixture(:newdev) do
    {:ok, newdev} = Discovery.create_newdev(@create_attrs)
    newdev
  end

  describe "index" do
    test "lists all newdevs", %{conn: conn} do
      conn = get conn, newdev_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Newdevs"
    end
  end

  describe "new newdev" do
    test "renders form", %{conn: conn} do
      conn = get conn, newdev_path(conn, :new)
      assert html_response(conn, 200) =~ "New Newdev"
    end
  end

  describe "create newdev" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, newdev_path(conn, :create), newdev: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == newdev_path(conn, :show, id)

      conn = get conn, newdev_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Newdev"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, newdev_path(conn, :create), newdev: @invalid_attrs
      assert html_response(conn, 200) =~ "New Newdev"
    end
  end

  describe "edit newdev" do
    setup [:create_newdev]

    test "renders form for editing chosen newdev", %{conn: conn, newdev: newdev} do
      conn = get conn, newdev_path(conn, :edit, newdev)
      assert html_response(conn, 200) =~ "Edit Newdev"
    end
  end

  describe "update newdev" do
    setup [:create_newdev]

    test "redirects when data is valid", %{conn: conn, newdev: newdev} do
      conn = put conn, newdev_path(conn, :update, newdev), newdev: @update_attrs
      assert redirected_to(conn) == newdev_path(conn, :show, newdev)

      conn = get conn, newdev_path(conn, :show, newdev)
      assert html_response(conn, 200) =~ "some updated from"
    end

    test "renders errors when data is invalid", %{conn: conn, newdev: newdev} do
      conn = put conn, newdev_path(conn, :update, newdev), newdev: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Newdev"
    end
  end

  describe "delete newdev" do
    setup [:create_newdev]

    test "deletes chosen newdev", %{conn: conn, newdev: newdev} do
      conn = delete conn, newdev_path(conn, :delete, newdev)
      assert redirected_to(conn) == newdev_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, newdev_path(conn, :show, newdev)
      end
    end
  end

  defp create_newdev(_) do
    newdev = fixture(:newdev)
    {:ok, newdev: newdev}
  end
end
