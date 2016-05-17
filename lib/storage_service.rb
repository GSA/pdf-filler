require 'aws-sdk'

class StorageService
  def initialize credentials
    @aws_access_key_id     = credentials[:aws_access_key_id]
    @aws_secret_access_key = credentials[:aws_secret_access_key]
  end

  def store file, options
    obj = client.bucket(options['bucket']).object(object_name(options))
    obj.put(body: file, acl: 'public-read')
    obj.public_url
  end

  private
  def creds
    [@aws_access_key_id, @aws_secret_access_key]
  end

  def client
    @client ||= Aws::S3::Resource.new(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(*creds)
    )
  end

  def object_name options
    File.join(options['remote_path'], File.basename(options['pdf']))
  end
end
