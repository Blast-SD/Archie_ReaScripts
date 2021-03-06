--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Toggle Arm Selected track.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(rmm)
   * Gave idea:   AlexLazer(rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [030620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local FirstSelTrack = reaper.GetSelectedTrack(0,0);
    if not FirstSelTrack then no_undo() return end;

    local arm = reaper.GetMediaTrackInfo_Value(FirstSelTrack,'I_RECARM');
    arm = math.abs(arm-1);

    for i = 1, reaper.CountSelectedTracks(0) do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local arm2 = reaper.GetMediaTrackInfo_Value(SelTrack,'I_RECARM');
        if arm2 ~= arm then;
           if not UNDO then;
               reaper.Undo_BeginBlock();
               reaper.PreventUIRefresh(1);
               UNDO = true;
           end;
           reaper.SetMediaTrackInfo_Value(SelTrack,'I_RECARM',arm);
        end;
    end;

    if UNDO then;
        reaper.PreventUIRefresh(-1);
        local ttl;
        if arm ~= 0 then ttl = 'Arm' else ttl = 'UnArm'end;
        reaper.Undo_EndBlock(ttl..' Selected track',-1);
    else;
        no_undo();
    end;



