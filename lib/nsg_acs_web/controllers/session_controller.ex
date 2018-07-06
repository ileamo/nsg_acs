defmodule NsgAcsWeb.SessionController do
  use NsgAcsWeb, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias NsgAcs.Auth.User
  alias NsgAcs.Repo
  alias NsgAcs.Auth.Guardian

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    conn
    |> put_layout(false)
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    # try to get user by unique username from DB
    user = Repo.get_by(User, username: username)
    # examine the result
    result =
      cond do
        # if user was found and provided password hash equals to stored
        # hash
        user && checkpw(password, user.password_hash) ->
          {:ok, login(conn, user)}

        # else if we just found the use
        user ->
          {:error, :unauthorized, conn}

        # otherwise
        true ->
          # simulate check password hash timing
          dummy_checkpw()
          {:error, :not_found, conn}
      end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> put_layout(false)
        |> render("new.html")
    end
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
  end

  def delete(conn, _) do
    conn
    |> logout()
    |> redirect(to: session_path(conn, :new))
  end

  defp logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end
end
