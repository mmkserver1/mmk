ActiveAdmin.register MeasurementThreshold do

  index do
    column :patient
    column :doctor
    column :type
    column :value

    default_actions
  end
end
