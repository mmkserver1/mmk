class SoftwarePackagesController < ApplicationController

  def index
    platform = params[:platform] || "android"
    @software_packages = SoftwarePackage.where(:platform => platform).all
    render :xml => @software_packages, :methods => [:url]
  end

  def recent
    platform = params[:platform] || "android"
    @software_packages = SoftwarePackage.order("created_at DESC").where(:platform => platform).first
    respond_to do |format|
      format.html { redirect_to @software_packages.filename.url}
      format.xml { render :xml => [*@software_packages], :methods => [:url] }
    end
  end
end
