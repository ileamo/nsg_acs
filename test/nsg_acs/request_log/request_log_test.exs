defmodule NsgAcs.RequestLogTest do
  use NsgAcs.DataCase

  alias NsgAcs.RequestLog

  describe "requests" do
    alias NsgAcs.RequestLog.Request

    @valid_attrs %{from: "some from", request: %{}, response: "some response"}
    @update_attrs %{from: "some updated from", request: %{}, response: "some updated response"}
    @invalid_attrs %{from: nil, request: nil, response: nil}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RequestLog.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert RequestLog.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert RequestLog.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = RequestLog.create_request(@valid_attrs)
      assert request.from == "some from"
      assert request.request == %{}
      assert request.response == "some response"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RequestLog.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, request} = RequestLog.update_request(request, @update_attrs)
      assert %Request{} = request
      assert request.from == "some updated from"
      assert request.request == %{}
      assert request.response == "some updated response"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = RequestLog.update_request(request, @invalid_attrs)
      assert request == RequestLog.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = RequestLog.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> RequestLog.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = RequestLog.change_request(request)
    end
  end
end
