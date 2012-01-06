Feature: Inherit values from parent environment in base.yml
  In order to enable large numbers of environments
  As a developer using Yacht
  I want to inherit values from a parent environment in a child environment

  Background:
    Given a file named "yacht/base.yml" with:
    """
    grandpa:
      :clan: McGillicuddy
      :age: 70
      :car:
        :make: oldsmobile
        :year: 1955
    pa:
      _parent: grandpa
      :age: 40
      :car:
        :year: 1980
    sonnyboy:
      _parent: pa
      :age: 10
      :car: tricycle
    """
    And I set Yacht's YAML directory to: "yacht"

  Scenario: Inherit from direct parent
    When I load Yacht with environment: "pa"
    Then Yacht should contain the following hash:
      """
        {
          '_parent' => 'grandpa',
          :clan     => 'McGillicuddy',
          :age      => 40,
          :car      =>  {
                          :make=>"oldsmobile",
                          :year=>1980
                        }
        }
      """

  Scenario: Inherit from direct parent and ancestors
    When I load Yacht with environment: "sonnyboy"
    Then Yacht should contain the following hash:
      """
        {
          '_parent' => 'pa',
          :clan     => 'McGillicuddy',
          :age      => 10,
          :car      =>  'tricycle'
        }
      """