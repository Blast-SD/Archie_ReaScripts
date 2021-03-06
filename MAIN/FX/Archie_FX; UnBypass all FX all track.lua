--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: UnBypass all FX all track
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [25.02.20]
   *                  + initialе
--]]

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local Undo;
    reaper.PreventUIRefresh(1);

    for i = 0,reaper.CountTracks(0) do;

        local Track;
        if i == 0 then;
            Track = reaper.GetMasterTrack(0);
        else;
            Track = reaper.GetTrack(0,i-1);
        end;

        ------
        local GetCount = reaper.TrackFX_GetCount(Track);
        for ifx = 1,GetCount do;
            local enabled = reaper.TrackFX_GetEnabled(Track,ifx-1);
            if not enabled then;
                if not Undo then Undo=1 reaper.Undo_BeginBlock()end;
                reaper.TrackFX_SetEnabled(Track,ifx-1,true);
            end;
        end;
        ------

        local GetRecCount = reaper.TrackFX_GetRecCount(Track);
        for ifx = 1,GetRecCount do;
            local enabled = reaper.TrackFX_GetEnabled(Track,0x1000000+ifx-1);
            if not enabled then;
                if not Undo then Undo=1 reaper.Undo_BeginBlock()end;
                reaper.TrackFX_SetEnabled(Track,0x1000000+ifx-1,true);
            end;
        end;
        ------
    end;

    reaper.PreventUIRefresh(-1);


    if Undo then;
        reaper.Undo_EndBlock('UnBypass all FX all track',-1);
    else;
        no_undo();
    end;
    reaper.UpdateArrange();


