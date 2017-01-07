require('mobdebug').start();
local treasure = RegisterMod("Treasureless", 2);

visited_t = false;
visited_b = false;
is_started = false;
keep_theres_options = true;

function treasure:activate_treasureless( )
  game = Game();
  local player = game:GetPlayer(0);
  floor = game:GetLevel();
  stage = floor:GetAbsoluteStage();

  if stage == 1 and is_started == false then
    Isaac.DebugString("is_started");
    is_started = true;
    visited_t = false;
    visited_b = false;
  end

  if stage < floor:GetAbsoluteStage() then
    Isaac.DebugString("is_new_stage");
    stage = floor:GetAbsoluteStage();

    if keep_theres_options == false then
      player:RemoveCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS);
    end

    keep_theres_options = true;
    visited_t = false;
    visited_b = false;
  end

  local room = game:GetRoom();

  if room:GetType() == RoomType.ROOM_TREASURE and visited_t == false then
      Isaac.DebugString("is_in_treasure");
      visited_t = true;
  end

  if visited_b == false and visited_t == false and room:GetType() == RoomType.ROOM_BOSS then
    Isaac.DebugString("is_in_boss");
    visited_b = true;
    keep_theres_options = player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS);

    if keep_theres_options == false then
      Isaac.DebugString("meet_conditions");
      player:AddCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS, 0, false);
    end
  end
end

treasure:AddCallback( ModCallbacks.MC_POST_UPDATE, treasure.activate_treasureless );
