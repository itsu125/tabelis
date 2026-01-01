# Railsが外部APIにアクセスするために必要
require "net/http"
require "uri"
require "json"

class Shop < ApplicationRecord
  # 保存前のバリデーションのタイミングで住所のGeocodingを実行
  before_validation :geocode_address, if: :should_geocode?
  before_validation :clear_geocode_if_address_blank

  belongs_to :user
  belongs_to :category, optional: true # 未選択でもOK
  has_one_attached :image
  has_many :shop_tags, dependent: :destroy
  has_many :tags, through: :shop_tags
  has_many :favorites, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user

  # 行きたい / 行った
  enum status: { want: 0, went: 1 }

  # バリデーション
  validates :name, presence: true
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      name memo address url category_id status rating
      created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category tags]
  end

  private
  # 住所変更時のみ Google Geocoding API を呼び出す
  def should_geocode?
    Rails.env.development? &&
      address.present? &&
      will_save_change_to_address?
  end

  def clear_geocode_if_address_blank
    if address.blank?
      self.latitude = nil
      self.longitude = nil
    end
  end

  # Google Geocoding API を呼んで Latitude / Longitude を更新
  def geocode_address
    api_key = Rails.application.credentials.google_geocoding[:api_key]
    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    url = URI.parse("#{base_url}?address=#{URI.encode_www_form_component(address)}&key=#{api_key}")

    response = Net::HTTP.get(url)
    result = JSON.parse(response)

    if result["status"] == "OK"
      location = result["results"][0]["geometry"]["location"]
      self.latitude = location["lat"]
      self.longitude = location["lng"]
    else
      # API失敗時:nilセット（地図非対応店舗として扱う）
      self.latitude = nil
      self.longitude = nil
      Rails.logger.warn "Geocoding failed for address: #{address}, reason: #{result["status"]}"
    end
  end
end
