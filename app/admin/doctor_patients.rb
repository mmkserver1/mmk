ActiveAdmin.register DoctorPatient do
 
  index do
    column :doctor
    column :patient

    default_actions
  end

end
