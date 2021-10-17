defmodule HTTP.LiveTest do
  use ExUnit.Case
  doctest HTTP

  @base_url "https://httpbin.org/"

  setup_all %{} do
    Http.start(nil, nil)

    :ok
  end

  @tag live_test: true
  test "delete" do
    result = HTTP.get(@base_url <> "delete")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "get" do
    result = HTTP.get(@base_url <> "get")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "head" do
    result = HTTP.get(@base_url <> "head")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "options" do
    result = HTTP.get(@base_url <> "options")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "patch" do
    result = HTTP.get(@base_url <> "patch")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "post" do
    result = HTTP.get(@base_url <> "post")

    assert result.status_code == 200
  end

  @tag live_test: true
  test "put" do
    result = HTTP.get(@base_url <> "put")

    assert result.status_code == 200
  end
end
