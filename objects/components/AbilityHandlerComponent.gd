extends Node
class_name AbilityHandlerComponent

@export var abilities: Array[Ability]


func add_ability(ability: Ability):
  abilities.append(ability)

  
func remove_ability(ability: Ability):
  abilities.erase(ability)


func use_ability(ability: Ability):
  if abilities.find(ability):
    ability.execute()
