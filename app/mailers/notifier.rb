class Notifier < ActionMailer::Base
  default :from => "#{Settings.robot_mailbox}@#{Settings.domain}"

  def notify(email,subject,text)
    mail(:to => email, :subject => subject,:body => text)
  end

end

