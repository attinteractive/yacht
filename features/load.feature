Feature: Load configuration settings
  In order to organize my configuration settings
  As a developer using Yacht
  I want to load configuration settings from an external source like a YAML file

  Background:
    Given a file named "yacht/base.yml" with:
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
    And I set Yacht's YAML directory to: "yacht"

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

  Scenario: Environments override with environments/*.yml
    Given a file named "yacht/environments/development.yml" with:
      """
      :api_key: some_crazy_environments_key
      :mail:
        :host: development.local
      """
      When I load Yacht with environment: "development"
      Then Yacht should contain the following hash:
        """
          {
            :api_key       =>  'some_crazy_environments_key',
            :partner_sites =>  [
                                  'twitter',
                                  'github'
                                ],
            :mail          =>  {
                                  :host => 'development.local',
                                  :from => 'Our great company'
                                }
          }
        """

    Given a file named "yacht/environments/production.yml" with:
      """
      _parent: development
      :mail:
        :host: development.local
      """
      When I load Yacht with environment: "development"
      Then Yacht should contain the following hash:
        """
          {
            :api_key       =>  'some_crazy_environments_key',
            :partner_sites =>  [
                                  'twitter',
                                  'github'
                                ],
            :mail          =>  {
                                  :host => 'development.local',
                                  :from => 'Our great company'
                                }
          }
        """

  Scenario: Local overrides with local.yml
    Given a file named "yacht/local.yml" with:
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
    Given a file named "yacht/whitelist.yml" with:
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

  Scenario: Generate a javascript snippet
    Given a file named "yacht/js_keys.yml" with:
    """
    - :partner_sites
    """
    When I use Yacht to generate a javascript snippet with environment: "development"
    Then the javascript snippet should contain:
    """
    ;var Yacht = {"partner_sites":["twitter","github"]};
    """
