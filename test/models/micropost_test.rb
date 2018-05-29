require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    # Micropostオブジェクトが有効であること
    # valid?を実行するとmodelのvalidationがtriggerされる
    assert @micropost.valid?
  end

  test "user id should be present" do
    # user_idのvalidtionチェックの確認
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  test "content should be present" do
    # contentが空白の場合、validationで検出
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    # contentが141文字の場合、validationで検出
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
