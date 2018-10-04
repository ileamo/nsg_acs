defmodule NsgAcsWeb.SessionController do
  use NsgAcsWeb, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias NsgAcs.Auth.User
  alias NsgAcs.Repo
  alias NsgAcs.Guard

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, params = %{"prev_path" => _prev_path}), do: new_aux(conn, params)
  def new(conn, _), do: new_aux(conn, %{"prev_path" => "/"})

  defp new_aux(conn, %{"prev_path" => prev_path}) do
    conn
    |> put_layout(false)
    |> render("new.html", prev_path: prev_path)
  end

  def create(
        conn,
        params = %{
          "session" => %{"username" => username, "password" => password, "prev_path" => prev_path}
        }
      ) do
    # try to get user by unique username from DB
    user = Repo.get_by(User, username: username)
    # examine the result
    result =
      cond do
        # if user was found and provided password hash equals to stored
        # hash
        user && checkpw(password, user.password_hash) ->
          {:ok, Guard.login(conn, user)}

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
        |> redirect(to: prev_path)

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> put_layout(false)
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guard.logout()
    |> redirect(to: session_path(conn, :new))
  end
end
