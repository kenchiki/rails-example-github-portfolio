CarrierWave.configure do |config|
  case Rails.env
  when 'production'
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: ENV.fetch('AWS_REGION'),
      host: ENV.fetch('AWS_HOST'),
      endpoint: ENV.fetch('AWS_ENDPOINT')
    }
    config.fog_directory = ENV.fetch('AWS_BUCKET')
    config.fog_public = true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
    config.storage = :fog
  else
    config.storage = :file
  end
end
