# == Schema Information
# Schema version: 27
#
# Table name: contacts
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  lead_id         :integer(4)
#  assigned_to     :integer(4)
#  reports_to      :integer(4)
#  first_name      :string(64)      default(""), not null
#  last_name       :string(64)      default(""), not null
#  access          :string(8)       default("Private")
#  title           :string(64)
#  department      :string(64)
#  source          :string(32)
#  email           :string(64)
#  alt_email       :string(64)
#  phone           :string(32)
#  mobile          :string(32)
#  fax             :string(32)
#  blog            :string(128)
#  linkedin        :string(128)
#  facebook        :string(128)
#  twitter         :string(128)
#  born_on         :date
#  do_not_call     :boolean(1)      not null
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  background_info :string(255)
#
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Contact do
  before(:each) do
    login
  end

  it "should create a new instance given valid attributes" do
    Contact.create!(:first_name => "Billy", :last_name => "Bones")
  end

  describe "Update existing contact" do
    before(:each) do
      @account = Factory(:account)
      @contact = Factory(:contact, :account => @account)
    end

    it "should create new account if requested so" do
      lambda { @contact.update_with_account_and_permissions({
        :account => { :name => "New account" },
        :contact => { :first_name => "Billy" }
      })}.should change(Account, :count).by(1)
      Account.last.name.should == "New account"
      @contact.first_name.should == "Billy"
    end

    it "should update the account another account was selected" do
      @another_account = Factory(:account)
      lambda { @contact.update_with_account_and_permissions({
        :account => { :id => @another_account.id },
        :contact => { :first_name => "Billy" }
      })}.should_not change(Account, :count)
      @contact.account.should == @another_account
      @contact.first_name.should == "Billy"
    end

    it "should drop existing Account if [create new account] is blank" do
      lambda { @contact.update_with_account_and_permissions({
        :account => { :name => "" },
        :contact => { :first_name => "Billy" }
      })}.should_not change(Account, :count)
      @contact.account.should == nil
      @contact.first_name.should == "Billy"
    end

    it "should drop existing Account if [-- None --] is selected from list of accounts" do
      lambda { @contact.update_with_account_and_permissions({
        :account => { :id => "" },
        :contact => { :first_name => "Billy" }
      })}.should_not change(Account, :count)
      @contact.account.should == nil
      @contact.first_name.should == "Billy"
    end
  end
end
