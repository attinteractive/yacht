Feature: Handle missing YAML files reasonably
  In order to ensure robustness and correctness of data
  Missing YAML files should cause an error to be raised when reasonable

  Background:
    Given a file named "base.yml" with:
    """
    development:
      api_key: some_fake_key
    """

  Scenario: No base.yml
    Given a file named "base.yml" does not exist
    When I try to use Yacht
    Then Yacht should raise an error with message: "Couldn't load base config"

  Scenario: No local.yml
    Given a file named "local.yml" does not exist
    When I try to use Yacht
    Then Yacht should not raise an error

  Scenario: No whitelist.yml but whitelist not used
    Given a file named "whitelist.yml" does not exist
    When I try to use Yacht
    Then Yacht should not raise an error

  Scenario: No whitelist.yml and whitelist used
    Given a file named "whitelist.yml" does not exist
    When I try to use Yacht with a whitelist
    Then Yacht should raise an error with message: "Couldn't load whitelist"