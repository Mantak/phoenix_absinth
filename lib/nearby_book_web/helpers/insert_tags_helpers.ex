defmodule NearbyBook.Helpers.InsertTagsHelpers do
  @moduledoc """
  检查存在tag，则更新tags表，并返回tags列表
  """
  alias Ecto.Multi
  alias NearbyBook.Tags

  def maybe_insert_tags(multi, %{tags: tags}) do
    insert_tags_fn = fn _ -> {:ok, Tags.insert_and_get_all_tags(tags)} end
    Multi.run(multi, :tags, insert_tags_fn)
  end

  def maybe_insert_tags(multi, _attrs), do: multi
end
