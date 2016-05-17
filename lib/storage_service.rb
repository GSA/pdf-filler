require 'aws-sdk'

class StorageService
  def initialize opts={}
    @aws_access_key_id     = opts[:aws_access_key_id]
    @aws_secret_access_key = opts[:aws_secret_access_key]
    @acl                   = opts[:aws_s3_acl]
  end

  def store file:, bucket:, path:
    obj = client.bucket(bucket).object(File.join(path, File.basename(file)))
    obj.put(body: file, acl: @acl)
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
end
