# coding: utf-8

module PatientsHelper

  def age(birthday)
    ((Date.today - birthday) / 365).floor
  end

  def measurement_date(dt)
    dt.strftime(" %d/%m/%Y  %H:%M:%S")
  end

  def get_blood_graph_data(num = 0)
    @bloodpressures_graph_data ||= @patient.bloodpressures.order('created_at desc').limit(7).sort_by(&:created_at).map{|a| [a.min,a.max,a.pulse,a.created_at.to_i*1000]}.inject([[],[],[]]){|r,o|r[0]<<[o[3],o[0]];r[1]<<[o[3],o[1]];r[2]<<[o[3],o[2]];r}
    @bloodpressures_graph_data[num]
  end
  def get_temperatures_graph_data
    @temperatures_graph_data ||= @patient.temperatures.order('created_at desc').limit(7).sort_by(&:created_at).map{|t| [t.value,t.created_at.to_i*1000]}.inject([]){|r,o| r<<[o[1],o[0]];r }
  end

  def get_glucoses_graph_data
    @glucoses_graph_data ||= @patient.glucoses.order('created_at desc').limit(7).sort_by(&:created_at).map{|t| [t.value,t.created_at.to_i*1000]}.inject([]){|r,o| r<<[o[1],o[0]];r }
  end

  def get_status_color(patient)
    case patient.measurements_alert
    when :day
      color = "#CC3333"
    when :month
      color = "#6699FF"
    end
  end
end
