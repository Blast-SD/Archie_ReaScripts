--[[
   * Category:    Preferences
   * Description: Solo in front' dimming +1 dB from set value
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Preferences > Mute/solo > Solo in front dimming
   * О скрипте:   Соло спереди' затемнение +1 дБ от заданного значения
   * GIF:         http://clck.ru/FWux8
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Supa75[RMM]
   * Gave idea:   Supa75[RMM]
   * Changelog:   +  initialе / v.1.0 [07042019]


   --=======================================================================================
         SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.965 +           --| http://www.reaper.fm/download.php
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (-) Arc_Function_lua v.2.2.9 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local DB =   1
             -- установите значение на сколько дб увеличить
             -- set the value to how many dB to increase



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ---------------------------------------------------
    function no_undo() reaper.defer(function()end) end;
    ---------------------------------------------------



    if type(DB)~= "number" then no_undo(); return end;
    local dimming = reaper.SNM_GetIntConfigVar("solodimdb10",0);

    local Set_dimming = dimming + (math.abs(DB)*10);
    if Set_dimming > 0 then Set_dimming = 0 end;

    reaper.SNM_SetIntConfigVar("solodimdb10",Set_dimming);

    local undo = reaper.SNM_GetIntConfigVar("solodimdb10",0)/10;

    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(undo.." / "..DB.." db Solo in front' dimming",1);