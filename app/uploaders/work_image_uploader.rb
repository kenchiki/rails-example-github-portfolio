class WorkImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [1600, 1600]

  version :thumb do
    process resize_to_limit: [400, 400]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "image.#{file.extension}" if original_filename.present?
  end
end
