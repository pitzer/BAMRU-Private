require 'spec_helper'

describe Member do

 describe "Object Attributes" do
   before(:each) { @obj = Member.new }
   specify { @obj.should respond_to(:first_name) }  
   specify { @obj.should respond_to(:last_name)  }  
   specify { @obj.should respond_to(:user_name)  }
 end

 describe "Associations" do
   before(:each) { @obj = Member.new }
   specify { @obj.should respond_to(:addresses)       }
   specify { @obj.should respond_to(:phones)          }
   specify { @obj.should respond_to(:emails)          }
   specify { @obj.should respond_to(:roles)           }
   specify { @obj.should respond_to(:photos)          }
   specify { @obj.should respond_to(:chats)           }
 end

 describe "Instance Methods" do
   before(:each) { @obj = Member.new }
 end

 describe "Validations" do
   context "self-contained" do
     it { should validate_presence_of(:user_name)               }
     it { should validate_presence_of(:first_name)              }
     it { should validate_presence_of(:last_name)               }
     it { should validate_format_of(:user_name).with("xxx_yyy") }
     it { should validate_presence_of(:user_name)               }
   end
   context "inter-object" do
     before(:each) do
       Member.create!(:user_name => "joe_louis", :password => "qwerasdf")
     end
     it { should validate_uniqueness_of(:user_name)        }
   end
 end

 describe "Object Creation" do
   it "works with a user_name attribute" do
     @obj = Member.new(:user_name => "xxx_yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.user_name.should == "xxx_yyy"
   end
   it "works with user name attributes" do
     @obj = Member.new(:first_name => "Xxx", :last_name => "Yyy")
     @obj.should be_valid
     @obj.first_name.should == "Xxx"
     @obj.last_name.should == "Yyy"
     @obj.user_name.should == "xxx_yyy"
   end
 end

 describe "Object Updating" do
   it "updates properly using #save" do
     @obj = Member.new(:user_name => "test_user")
     @obj.ham = "asdf"
     @obj.save
     @obj.should be_valid
   end
   it "updates properly using #update_attributes" do
     @obj = Member.create!(:user_name => "test_user")
     @obj.update_attributes(:ham => "asdf")
     @obj.should be_valid
   end
 end

  describe "Object Retrieval" do
    it "retrieves a valid object" do
      Member.create!(:user_name => "test_user")
      Member.first.should be_valid
    end
  end

  describe "#new_user_name_from_names" do
    before(:each) {@obj = Member.new(:first_name=>"Joe", :last_name=>"Smith")}
    it "should return the correct user_name" do
      @obj.new_username_from_names.should == "joe_smith"
    end
  end

  describe "#new_names_from_user_name" do
    before(:each) {@obj = Member.new(:user_name => "joe_smith")}
    it "should return the correct names" do
      @obj.new_names_from_username.should == ["Joe","Smith"]
    end
  end

  describe "#full_name" do
    describe "reader" do
      it "returns the correct string" do
        @obj = Member.create(:user_name => "joe_smith", :password => "asdfasdf")
        @obj.full_name.should == "Joe Smith"
      end
    end
    describe "writer" do
      before(:each) { @obj = Member.new(:user_name => "abc_def") }
      it "handle valid input" do
        @obj.update_attributes :full_name => "Joe Smith"
        @obj.should be_valid
        @obj.first_name.should == "Joe"
        @obj.last_name.should  == "Smith"
        @obj.full_name.should  == "Joe Smith"
        @obj.user_name.should  == "joe_smith"
      end
      it "handle valid lower case it" do
        @obj.update_attributes :full_name => "joe smith"
        @obj.should be_valid
        @obj.first_name.should == "Joe"
        @obj.last_name.should  == "Smith"
        @obj.full_name.should  == "Joe Smith"
        @obj.user_name.should  == "joe_smith"
      end
      it "returns an invalid object with empty input" do
        @obj.save
        @obj.update_attributes :full_name => ""
        @obj.should_not be_valid
      end
      it "returns an invalid object with incomplete input" do
        @obj.save
        @obj.update_attributes :full_name => "joe"
        @obj.should_not be_valid
      end
      it "works with multi word input" do
        @obj.save
        @obj.update_attributes :full_name => "dep. joe smith"
        @obj.should be_valid
        @obj.title.should == "Dep."
        @obj.first_name.should == "Joe"
        @obj.last_name.should == "Smith"
        @obj.user_name.should == "joe_smith"
      end
      it "works with multi word last names" do
        @obj.save
        @obj.update_attributes :full_name => "sarah roberts smith"
        @obj.should be_valid
        @obj.title.should == ""
        @obj.first_name.should == "Sarah"
        @obj.last_name.should == "Roberts Smith"
        @obj.user_name.should == "sarah_roberts_smith"
      end
      it "works with dashes" do
        @obj.save
        @obj.update_attributes :full_name => "Kito Smith-Jones"
        @obj.should be_valid
        @obj.first_name.should == "Kito"
        @obj.last_name.should == "Smith-Jones"
        @obj.user_name.should == "kito_smith-jones"
      end
      it "works with other punctuation" do
        @obj.save
        @obj.update_attributes :full_name => "Kito Smith#jones"
        @obj.should_not be_valid
        @obj.first_name.should == "Kito"
        @obj.last_name.should == "Smith#jones"
        @obj.user_name.should == "kito_smith#jones"
      end
      it "works with numbers" do
        @obj.save
        @obj.update_attributes :full_name => "Kito Smith6jones"
        @obj.should_not be_valid
        @obj.first_name.should == "Kito"
        @obj.last_name.should == "Smith6jones"
        @obj.user_name.should == "kito_smith6jones"
      end
    end
  end

  describe "#full_roles" do
    it "returns the correct string" do
      hash1 = {:user_name => "joe_smith", :password => "asdfasdf", :typ => "FM"}
      @obj = Member.create!(hash1)
      hash2 = {:typ => "Bd"}
      @obj.roles << Role.create!(hash2)
      @obj.full_roles.should be_a(String)
      @obj.full_roles.should == "Bd FM"
    end
  end

  describe "#remember_me_token" do
    context "when creating an object" do
      it "creates a remember_me token" do
        @obj = Member.create :user_name => "test_user"
        @obj.remember_me_token.should_not be_nil
        @obj.remember_me_token.should be_a(String)
        #@obj.remember_me_token.length.should == 16
      end
    end
    context "when updating a password" do
      it "resets the remember_me token" do
        @obj = Member.create :user_name => "test_user"
        original_token = @obj.remember_me_token
        @obj.update_attributes(:password => "welcome2")
        @obj.remember_me_token.should_not be_nil
        @obj.remember_me_token.should_not == original_token
      end
    end
    context "when updating a password" do
      it "resets the remember_me token" do
        @obj = Member.create :user_name => "test_user"
        original_token = @obj.remember_me_token
        original_digest = @obj.password_digest
        @obj.update_attributes(:password => "welcome2")
        @obj.remember_me_token.should_not be_nil
        @obj.remember_me_token.should_not == original_token
        @obj.password_digest.should_not == original_token
      end
    end
    context "when updating another parameter" do
      it "does not reset the remember_me token" do
        @obj = Member.create :user_name => "test_user"
        original_token = @obj.remember_me_token
        @obj.sign_in_count = 10
        @obj.save
        @obj.remember_me_token.should_not be_nil
        @obj.remember_me_token.should == original_token
      end
    end
  end

  describe "#scrubbed_errors / user_name" do
    it "detects invalid user_names" do
      @obj = Member.new(:user_name => "as#x_qwer")
      @obj.should_not be_valid
    end
    it "invalid :first_name returns an error hash" do
      @obj = Member.new(:user_name => "as#x_qwer")
      @obj.valid?
      @obj.scrubbed_errors.should be_a(Hash)
      @obj.scrubbed_errors.length.should == 1
      @obj.scrubbed_errors.keys.first.should == :first_name
    end
    it "invalid :last_name returns an error hash" do
      @obj = Member.new(:user_name => "asx_qw#er")
      @obj.valid?
      @obj.scrubbed_errors.should be_a(Hash)
      @obj.scrubbed_errors.length.should == 1
      @obj.scrubbed_errors.keys.first.should == :last_name
    end
    it "invalid :password returns an error hash" do
      @obj = Member.new(:user_name => "asx_qw#er", :password => '12#32')
      @obj.valid?
      @obj.scrubbed_errors.should be_a(Hash)
      @obj.scrubbed_errors.length.should == 2
      @obj.scrubbed_errors.keys.should include(:password)
      @obj.scrubbed_errors.keys.should include(:last_name)
    end
    it "valid :username, invalid :password" do
      @obj = Member.new(:user_name => "asx_qwer", :password => '12#32')
      @obj.should_not be_valid
      @obj.scrubbed_errors.should be_a(Hash)
      @obj.scrubbed_errors.length.should == 1
      @obj.scrubbed_errors.keys.should include(:password)
    end
    it "return no errors with valid input" do
      @obj = Member.new(:user_name => "jim_valid")
      @obj.should be_valid
      @obj.scrubbed_errors.length.should == 0
    end
  end

  describe "nested attributes" do
    before(:each) do
      @mem1 = <<-EOF
  {
    "emails_attributes":[
      {
        "address":"joe@minger.com",
        "typ":"Work",
        "pagable":"1"
      }
    ],
    "avail_ops_attributes":[],
    "avail_dos_attributes":[],
    "ham":null,
    "certs_attributes":[],
    "typ":"A",
    "first_name":"Joe",
    "v9":"928",
    "addresses_attributes":[
      {
        "zip":"29313",
        "address2":"",
        "address1":"PO Box 6256",
        "city":"Yolo",
        "typ":"Work",
        "state":"MS"
      }
    ],
    "roles_attributes":[],
    "phones_attributes":[
      {
        "typ":"Mobile",
        "number":"725-782-4437",
        "pagable":"0"
      }
    ],
    "last_name":"Minger"
  }
      EOF
      @att1 = JSON.parse(@mem1, :symbolize_names => true)
    end
    it "creates a suite of related objects using nested attributes" do
      member_count = Member.count
      phone_count  = Phone.count
      email_count  = Email.count
      addrs_count  = Address.count
      @obj = Member.create!(@att1)
      @obj.should be_valid
      Member.count.should  == 1 + member_count
      Phone.count.should   == 1 + phone_count
      Email.count.should   == 1 + email_count
      Address.count.should == 1 + addrs_count
    end
  end

end

# == Schema Information
#
# Table name: members
#
#  id                         :integer         not null, primary key
#  title                      :string(255)
#  first_name                 :string(255)
#  last_name                  :string(255)
#  user_name                  :string(255)
#  typ                        :string(255)
#  ham                        :string(255)
#  v9                         :string(255)
#  admin                      :boolean         default(FALSE)
#  developer                  :boolean         default(FALSE)
#  role_score                 :integer
#  typ_score                  :integer
#  password_digest            :string(255)
#  sign_in_count              :integer         default(0)
#  ip_address                 :string(255)
#  remember_me_token          :string(255)
#  forgot_password_token      :string(255)
#  forgot_password_expires_at :datetime
#  google_oauth_token         :string(255)
#  remember_created_at        :time
#  created_at                 :datetime
#  updated_at                 :datetime
#  current_do                 :boolean         default(FALSE)
#  last_sign_in_at            :datetime
#  dl                         :string(255)
#

