# frozen_string_literal: true

require 'aws-sdk'

module GitLfsS3
  module CephPresignerService
    extend self
    extend AwsHelpers

    def signed_url(obj)
      @@s3 ||= Aws::S3::Resource.new(region: GitLfsS3::Application.settings.region,
                                     access_key_id: GitLfsS3::Application.settings.aws_access_key_id,
                                     secret_access_key: GitLfsS3::Application.settings.aws_secret_access_key)
      bucket = s3.bucket(obj.bucket_name).object(obj.key)
      bucket.presigned_url(:put, expires_in: 2.hours.from_now, acl: 'private').
        tap do |url|
        Rails.logger.debug('using ' +url)
      end
    end
  end
end
