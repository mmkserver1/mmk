ActiveAdmin.register SoftwarePackage do

  form :html=>{:multipart => true} do |f|
    f.inputs do
      f.input :version
      f.input :build
      f.input :filename, :as => :file
      f.input :filename2, :as => :file
      f.input :platform, :as => :select, :collection => [:android, :j2me]
    end
    f.buttons
  end

end
