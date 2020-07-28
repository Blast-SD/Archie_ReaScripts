--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Track; Arm only Selected tracks.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
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
     
     
    local CountSelTrack = reaper.CountSelectedTracks(0); 
    if CountSelTrack == 0 then no_undo() return end; 
     
     
    reaper.Undo_BeginBlock(); 
    reaper.PreventUIRefresh(1); 
    reaper.ClearAllRecArmed(); 
     
    for i = 1, CountSelTrack do; 
        local SelTrack = reaper.GetSelectedTrack(0,i-1); 
        local arm = reaper.GetMediaTrackInfo_Value(SelTrack,'I_RECARM'); 
        if arm ~= 1 then; 
            reaper.SetMediaTrackInfo_Value(SelTrack,'I_RECARM',1); 
        end; 
    end; 
     
    reaper.PreventUIRefresh(-1); 
    reaper.Undo_EndBlock('Arm only Selected tracks',-1); 
     
     
     
     
     