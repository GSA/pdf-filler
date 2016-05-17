require 'aws-sdk'

class StorageService
  def initialize opts={}
    @aws_access_key_id     = opts[:aws_access_key_id]
    @aws_secret_access_key = opts[:aws_secret_access_key]
    @bucket                = opts[:aws_s3_bucket]
    @acl                   = opts['aws_s3_acl']
  end

  def store file, options
    obj = client.bucket(@bucket).object(object_name(options))
    # Make this private!
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
