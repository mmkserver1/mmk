ActiveAdmin.register Patient do

  filter :id

  index do
    column :id
    column :email
    column :full_name, :sortable =>false
    column :gender
    column :birthday
    column :phone

    column :doctors do |patient|
      doctors = patient.doctors.map do |doctor|
        link_to doctor, admin_doctor_path(doctor)
      end
      doctors.join("<br>").html_safe
    end

    default_actions
  end

  form do |f|

    f.inputs do
      f.input :email , :as => :string
      f.input :last_name
      f.input :first_name
      f.input :middle_name
      f.input :birthday,  :start_year => Time.now.year - 100, :end_year => Time.now.year
      f.input :gender, :as => :select, :collection =>  User::GENDERS.map { |g| [I18n.t(g), g] }
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
end

