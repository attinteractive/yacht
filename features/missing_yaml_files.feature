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
    Then a "YachtLoader::LoadError" error with message "Couldn't load base config" should be raised when I try to use Yacht

  Scenario: No local.yml
    Given a file named "local.yml" does not exist
    Then I should not receive an error when I try to use Yacht

  Scenario: No whitelist.yml
    Given a file named "whitelist.yml" does not exist
    Then I should not receive an error when I try to use Yacht
    But a "YachtLoader::LoadError" error with message "Couldn't load whitelist" should be raised when I try to use Yacht with a whitelist