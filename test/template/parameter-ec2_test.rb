require 'abstract_unit'

class ParameterEc2Test < Minitest::Test
  def test_normal
    template = <<-EOS
_parameter_ec2 "test"
    EOS
    act_template = run_client_as_json(template)
    allowed_values = []
    EC2_INSTANCE_TYPES.each do |type|
      allowed_values << "#{type}"
    end
    allowed_values = JSON.generate(allowed_values)
                       .gsub("[", "[\n      ")
                       .gsub("\",", "\",\n      ")
                       .gsub("\"]", "\"\n    ]")
    exp_template = <<-EOS
{
  "TestInstanceType": {
    "Type": "String",
    "Default": "#{EC2_DEFAULT_INSTANCE_TYPE}",
    "AllowedValues": #{allowed_values},
    "Description": "test instance type"
  },
  "TestDataVolumeSize": {
    "Type": "String",
    "Default": "100",
    "Description": "test data volume size"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter_ec2 "test", iam_instance: "test", key_name: "test"
    EOS
    act_template = run_client_as_json(template)
    allowed_values = []
    EC2_INSTANCE_TYPES.each do |type|
      allowed_values << "#{type}"
    end
    allowed_values = JSON.generate(allowed_values)
                       .gsub("[", "[\n      ")
                       .gsub("\",", "\",\n      ")
                       .gsub("\"]", "\"\n    ]")
    exp_template = <<-EOS
{
  "TestInstanceType": {
    "Type": "String",
    "Default": "#{EC2_DEFAULT_INSTANCE_TYPE}",
    "AllowedValues": #{allowed_values},
    "Description": "test instance type"
  },
  "TestIamInstanceProfile": {
    "Type": "String",
    "Default": "test",
    "Description": "test iam instance profile"
  },
  "TestDataVolumeSize": {
    "Type": "String",
    "Default": "100",
    "Description": "test data volume size"
  },
  "TestKeyName": {
    "Type": "AWS::EC2::KeyPair::KeyName",
    "Default": "test",
    "Description": "test key name"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
