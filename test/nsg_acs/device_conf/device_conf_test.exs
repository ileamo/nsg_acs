defmodule NsgAcs.DeviceConfTest do
  use NsgAcs.DataCase

  alias NsgAcs.DeviceConf

  describe "devices" do
    alias NsgAcs.DeviceConf.Device

    @valid_attrs %{key: "some key", params: %{}}
    @update_attrs %{key: "some updated key", params: %{}}
    @invalid_attrs %{key: nil, params: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeviceConf.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert DeviceConf.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert DeviceConf.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = DeviceConf.create_device(@valid_attrs)
      assert device.key == "some key"
      assert device.params == %{}
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeviceConf.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, device} = DeviceConf.update_device(device, @update_attrs)
      assert %Device{} = device
      assert device.key == "some updated key"
      assert device.params == %{}
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = DeviceConf.update_device(device, @invalid_attrs)
      assert device == DeviceConf.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = DeviceConf.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> DeviceConf.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = DeviceConf.change_device(device)
    end
  end
end
