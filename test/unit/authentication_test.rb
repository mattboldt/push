# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#  secret     :string(255)
#  username   :string(255)
#

require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Authentication.new.valid?
  end
end
