java_import 'org.apollo.game.message.impl.HintIconMessage'

on :message, :npc_action do |player, message|
  target                     = $world.npc_repository.get message.index

  # unless target.attacking
  #   target_combat_state        = get_combat_state target
  #   target_combat_state.target = player
  #
  #   target.start_action CombatAction.new(target)
  # end

  player_combat_state        = player.get_combat_state
  player_combat_state.target = target

  player.send HintIconMessage.for_npc(target.index)
  player.walking_queue.clear
  player.start_action CombatAction.new(player) unless player_combat_state.is_attacking?
end

on :message, :player_action do |player, message|

end

schedule 0 do |_task|
  $world.player_repository.each { |player| player.attack_timer = player.attack_timer + 1 }
  $world.npc_repository.each { |npc| npc.attack_timer = npc.attack_timer + 1 }
end
