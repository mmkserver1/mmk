# coding: utf-8

require "net/http"
require "transliteration"

class Notification < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
  after_create :send_notification

  attr_accessor :threshold
  attr_accessor :measurement

  # mobdoc API for sms
  SMS_API_HOST = "admin.mobdoc.ru"
  SMS_API_URL  = "/smsend.php"
  SMS_API_KEY = "sHIm2ySQEu3gU.tDZ!W#"

  def send_notification
    send_notification_to_doctor unless doctor.nil?
  end

  def send_notification_to_doctor
    unless measurement.nil?
      threshold_notification unless threshold.nil?
      measurement_notification if threshold.nil?
    end
  end

  def measurement_notification
    doctor_email  = doctor.email
    email_subject = "Пациент #{patient.first_name} #{patient.last_name}: получены новые измерения."
    email_text    = "#{I18n.t(measurement.class.to_s.demodulize.downcase).mb_chars.capitalize} #{measurement}."
    send_notification_email doctor_email, email_subject, email_text
  end

  def threshold_notification
    doctor_email  = doctor.email
    email_subject = "Пациент #{patient.first_name} #{patient.last_name}: превышены пороговые значения."
    email_text    = "#{I18n.t(measurement.class.to_s.demodulize.downcase).mb_chars.capitalize} #{measurement}."
    email_text   += " #{threshold}."
    send_notification_email doctor_email, email_subject, email_text

    doctor_phone = doctor.phone.to_s
    sms_text = "#{patient.first_name} #{patient.last_name} #{email_text}"
    send_notification_sms doctor_phone, sms_text
  end

  def send_notification_sms(phone,text)
    delay.send_sms_via_mobdoc(phone,text)
  end

  def send_sms_via_mobdoc(phone,text)
    payload = {
      "KEY" => SMS_API_KEY,
      "ABONENT" => phone,
      "BODY" =>  Russian::Transliteration.transliterate(text)
    }
    req = Net::HTTP::Post.new(SMS_API_URL, initheader = {'Content-Type' =>'application/json'})
    req.body = payload.to_json
    response = Net::HTTP.new(SMS_API_HOST, 80).start {|http| http.request(req) }
  end

  def send_notification_email(email, subject, text)
    logger.info "Sending email notification with id##{id} to #{email} with subject #{subject}"
    Notifier.delay.notify(email, subject, text)
  end
end
