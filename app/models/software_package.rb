class SoftwarePackage < ActiveRecord::Base
  mount_uploader :filename, SoftwarePackageUploader
  mount_uploader :filename2, SoftwarePackageUploader

  validates_presence_of :filename

  def url
    filename.url
  end

end
