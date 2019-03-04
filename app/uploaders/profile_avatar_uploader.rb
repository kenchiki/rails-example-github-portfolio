class ProfileAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [400, 400]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "avatar.#{file.extension}" if original_filename.present?
  end
end
