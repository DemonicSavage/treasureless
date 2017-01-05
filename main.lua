require('mobdebug').start()
local treasure = RegisterMod("Treasureless", 1);

visited_t = false;
visited_b = false;
floor = nil;
keep_theres_options = true;

stage = 0

function treasure:text_render( )
  Isaac.RenderText("Treasureless v0.0.8.1", 50, 15, 255, 255, 255, 255);
end

function treasure:activate_treasureless( )
  game = Game();
  local player = game:GetPlayer(0);

  if floor == nil then
    Isaac.DebugString("is_started");
    floor = game:GetLevel();
    stage = floor:GetAbsoluteStage();
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

treasure:AddCallback( ModCallbacks.MC_POST_RENDER, treasure.text_render );
treasure:AddCallback( ModCallbacks.MC_POST_UPDATE, treasure.activate_treasureless );
