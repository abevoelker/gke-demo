require "shrine"
require "down"

# Plugins to load for every uploader
Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type

require "shrine/storage/file_system"
Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
}
