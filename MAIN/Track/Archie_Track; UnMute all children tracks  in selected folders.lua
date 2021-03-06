--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; UnMute all children tracks in selected folders.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [080620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local PARENT_FOLDER_UNMUTE = true; -- true / false

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;


    for i = 1,CountSelTrack do;
        local TrackSel = reaper.GetSelectedTrack(0,i-1);
        local fold = reaper.GetMediaTrackInfo_Value(TrackSel,"I_FOLDERDEPTH")==1;
        if fold then;
            ----
            if PARENT_FOLDER_UNMUTE == true then;
                if not UNDO then;
                    reaper.Undo_BeginBlock();
                    reaper.PreventUIRefresh(1);
                    UNDO = true;
                end;
                reaper.SetMediaTrackInfo_Value(TrackSel,"B_MUTE",0);
            end;
            ----
            local Depth = reaper.GetTrackDepth(TrackSel);
            local numb = reaper.CSurf_TrackToID(TrackSel,false);
            for i2 = numb,reaper.CountTracks(0)-1 do;
                local track = reaper.GetTrack(0,i2);
                if track then;
                    local depth2 = reaper.GetTrackDepth(track);
                    if depth2 > Depth then;
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        reaper.SetMediaTrackInfo_Value(track,"B_MUTE",0);
                    else;
                        break;
                    end;
                end;
            end;
        end;
    end;


    if UNDO then;
        reaper.Undo_EndBlock("UnMute all children tracks in selected folders",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;


