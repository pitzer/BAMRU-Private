require 'spec_helper'

describe Participant do

  def valid_params
    {}
  end

  describe "Object Attributes" do
    before(:each) { @obj = Participant.new }
    specify { @obj.should respond_to(:role)              }
    specify { @obj.should respond_to(:start)             }
    specify { @obj.should respond_to(:finish)            }
  end

  describe "Associations" do
    before(:each) { @obj = Participant.new(valid_params) }
    specify { @obj.should respond_to(:member)       }
    specify { @obj.should respond_to(:period)       }
  end

  describe "Instance Methods" do
  end

  describe "Validations" do
  end

end


# == Schema Information
#
# Table name: participants
#
#  id             :integer         not null, primary key
#  ol             :boolean         default(FALSE)
#  member_id      :integer
#  period_id      :integer
#  comment        :string(255)
#  en_route_at    :datetime
#  return_home_at :datetime
#  signed_in_at   :datetime
#  signed_out_at  :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

