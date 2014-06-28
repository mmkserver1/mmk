# encoding: UTF-8
class ChangeGenderOfUsers < ActiveRecord::Migration
  def up
    @genders = []
    User.all.map do |u|
       gender = case u.gender.to_s.mb_chars.downcase.to_s # to_s two times because can be nil and returning not a string
         when "женский" || "female"
           0
         else
           1
       end
       @genders << [u, gender]
    end
    change_column :users, :gender, :integer
    User.reset_column_information
    @genders.each { |g| g[0].update_attributes(:gender => g[1])}
  end

  def down
    @genders = []
    User.all.map do |u|
       gender = case u.gender
         when 0
           "female"
         else
           "male"
       end
       @genders << [u, gender]
    end
    change_column :users, :gender, :string
    User.reset_column_information
    @genders.each { |g| g[0].update_attributes(:gender => g[1])}
  end
end
