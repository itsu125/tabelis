require 'rails_helper'

RSpec.describe "Homes", type: :request do
  it "未ログイン時にroot_pathへアクセスできる" do
    get root_path
    expect(response).to have_http_status(:success)
  end
end
