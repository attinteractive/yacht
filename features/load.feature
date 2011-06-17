Feature: Load configuration settings
  In order to organize my configuration settings
  As a developer using Yacht
  I want to load configuration settings from an external source like a YAML file

  Background:
    Given a file named "base.yml" with:
    """
    default:
      :api_key: some_fake_key
      :partner_sites:
        - twitter
        - github
      :mail:
        :host: localhost
        :from: Our great company
    development:
      :api_key: some_development_key
    production:
      :api_key: the_real_mccoy
      :partner_sites:
        - facebook
      :mail:
        host: example.com
        reply-to: info@example.com
    """

  Scenario: Load from YAML
    When I load Yacht with environment: "development"
    Then Yacht should contain the following hash:
      """
        {
          :api_key       =>  'some_development_key',
          :partner_sites =>  [
                                'twitter',
                                'github'
                              ],
          :mail          =>  {
                                :host => 'localhost',
                                :from => 'Our great company'
                              }
        }
      """

  Scenario: Local overrides with local.yml
    Given a file named "local.yml" with:
      """
      :api_key: some_crazy_local_key
      """
      When I load Yacht with environment: "development"
      Then Yacht should contain the following hash:
        """
          {
            :api_key       =>  'some_crazy_local_key',
            :partner_sites =>  [
                                  'twitter',
                                  'github'
                                ],
            :mail          =>  {
                                  :host => 'localhost',
                                  :from => 'Our great company'
                                }
          }
        """

  Scenario: Whitelisting with whitelist.yml
    Given a file named "whitelist.yml" with:
    """
    - :partner_sites
    """
    When I define the constant "MyYacht" with environment: "development" using a whitelist
    Then the constant "MyYacht" should contain the following hash:
      """
        {
          :partner_sites =>  [
                                'twitter',
                                'github'
                              ]
        }
      """

  @js
  Scenario: Generate a Yacht.js file
    Given a file named "js_keys.yml" with:
    """
    - :partner_sites
    """
    When I use Yacht to generate a javascript file with environment: "development"
    Then the file "Yacht.js" should contain:
    """
    ;var Yacht = {"partner_sites":["twitter","github"]};
    """