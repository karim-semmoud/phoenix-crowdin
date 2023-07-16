defmodule PhoenixCrowdinWeb.LocaleTest do
  use PhoenixCrowdinWeb.ConnCase

  test "Select Browser locale if it is available" do
    conn =
      build_conn()
      |> put_req_header("accept-language", "fr")
      |> get("/")

    assert html_response(conn, 200) =~ "La tranquillité d&#39;esprit du prototype à la production"
  end

  test "Select default locale if no browser language" do
    conn =
      build_conn()
      |> put_req_header("accept-language", "")
      |> get("/")

    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  test "Select default locale if browser locale doesn't exist" do
    conn =
      build_conn()
      |> put_req_header("accept-language", "de")
      |> get("/")

    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  test "Select top available browser locale if many browser locales" do
    conn =
      build_conn()
      |> put_req_header("accept-language", "de, fr, en")
      |> get("/")

    assert html_response(conn, 200) =~ "La tranquillité d&#39;esprit du prototype à la production"
  end

  test "Select param locale if param locale exist", %{conn: conn} do
    conn = get(conn, ~p"/?locale=fr")
    assert html_response(conn, 200) =~ "La tranquillité d&#39;esprit du prototype à la production"
  end

  test "Select default locale if param locale doesnt exist", %{conn: conn} do
    conn = get(conn, ~p"/?locale=de")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

end
