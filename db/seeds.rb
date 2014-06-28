# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#[%w{Винокуров Михаил vinokurov.mike@gmail.com},
#%w{Кормильцын Сергей me@way5.ru},
#%w{Терехов Александр terekhovap@mail.ru},
#%w{Алядулин Ренад alyautdin@mail.ru Николаевич},
#%w{Руденко Николай rudenko-n@mail.ru},
#%w{Филиппов Кирилл kbfilippov@yahoo.com Борисович},
#%w{Харлампович Олег nko-zpp@yandex.ru Яковлевич}].each do |data|

doctor = Doctor.create do |d|
  d.first_name ="Сергей"
  d.last_name = "Подтынный"
  d.middle_name ="Сергеевич"
  d.email = "ssp@spb.com"
  d.password="123456"
  d.password_confirmation=d.password
end


last_names = %w{ Петров Каюмов Петай Сибиряков Англоа Иванов Федков Мамонов Рязанов Кошкин }
first_names = %w{ Василий Денис Петр Антон Сергей Павел Ярополк Тимур Евгений Владимир Дмитрий Андрей }
middle_names = %w{ Сергеевич Петрович Иванович Денисович Андреевич Павлович Антонович }

7.times do
patient = Patient.create do |p|
  p.first_name = first_names.at rand(first_names.size)
  p.last_name = last_names.at rand(last_names.size)
  p.middle_name = middle_names.at rand(middle_names.size)
  p.email = "a#{rand(100)}b#{rand(100)}c#{rand(100)}@spb.com"
  p.password="123456"
  p.password_confirmation=p.password
  p.birthday = Time.now - Random.new.rand(20..45).years - rand(365).days
end

7.times do |t|
  patient.bloodpressures<<Measurements::Bloodpressure.create(:max=>Random.new.rand(140..190), :min=> Random.new.rand(50..100) ,:pulse =>Random.new.rand(50..120), :created_at => Time.now - t.day - rand(180).minutes  )
end

7.times do |t|
  patient.temperatures<<Measurements::Temperature.create( :value =>(36.4+rand).round(1), :units =>'C', :created_at => Time.now - t.day - rand(180).minutes)
end

patient.cardiograms<<Measurements::Cardiogram.from_ECG(File.expand_path "../seeds/first.ecg", __FILE__)

doctor.patients<<patient
end
