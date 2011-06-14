Feature: Handle missing YAML files reasonably
  In order to ensure robustness and correctness of data
  Missing YAML files should cause an error to be raised when reasonable

  Scenario: No base.yml
    Given a file named "base.yml" does not exist
    Then a "YachtLoader::LoadError" error with message "Couldn't load base config" should be raised when I try to use Yacht
