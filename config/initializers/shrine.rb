require "shrine"
require "down"

# Plugins to load for every uploader
Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type

if Rails.env.production?
  require "shrine/storage/google_cloud_storage"
  shared_options = {
    bucket: ENVied.IMAGE_STORAGE_BUCKET_NAME,
    default_acl: "publicRead",
    object_options: {
      cache_control: "public, max-age: 31536000" # 1 year
    },
  }
  Shrine.storages = {
    cache: Shrine::Storage::GoogleCloudStorage.new(prefix: "cache", **shared_options),
    store: Shrine::Storage::GoogleCloudStorage.new(prefix: "store", **shared_options),
  }

  # Make all URLs public
  url_options = Shrine.storages.keys.inject({}) do |hash, storage_key|
    hash.update(storage_key => {
      public: true,
      host: "#{ENVied.IMAGE_STORAGE_BUCKET_NAME}.storage.googleapis.com".freeze,
    })
  end
  Shrine.plugin :default_url_options, url_options
else
  require "shrine/storage/file_system"
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
  }
end
