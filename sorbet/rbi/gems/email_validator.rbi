# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/email_validator/all/email_validator.rbi
#
# email_validator-756f4226d254
class EmailValidator < ActiveModel::EachValidator
  def self.invalid?(value, options = nil); end
  def self.regexp(options = nil); end
  def self.valid?(value, options = nil); end
  def validate_each(record, attribute, value); end
end