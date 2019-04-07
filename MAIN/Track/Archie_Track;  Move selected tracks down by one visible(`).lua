--[[
   * Category:    Track
   * Description: Move selected tracks down by one visible*
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Move selected tracks down by one visible*
   * О скрипте:   Переместить выбранные треки вниз на один видимый*
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Provides:    
   *              [main] . > Archie_Track;  Move selected tracks down by one visible(`).lua
   *              [main] . > Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua
   *              [main] . > Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua
   * Changelog:   
   *              + Ignoring tracks in collapsed folders when scrolling / v.1.03 [06042019]
   
   *              + indent when scrolling / v.1.01 [05042019]
   *              +  initialе / v.1.0 [04042019]
   
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]]
    
    
    

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local Scroll = 1
            --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ \ DISABLE SCROLLING                            
            --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ  \ ENABLE SCROLLING
            ------------------------------------------------------ 
    
    
    local indent = 1
                -- | ОТСТУП ПРИ ПРОКРУТКЕ, (В ТРЕКАХ)
                -- | INDENT WHEN SCROLLING, (IN TRACKS)
                ---------------------------------------
    
    
    local Ignore_superCollapse = 1
                             -- = 0 | НЕ ИГНОРИРОВАТЬ ТРЕКИ У СВЕРНУТЫХ ПАПОК ПРИ СКРОЛЛЕ
                             -- = 1 | ИГНОРИРОВАТЬ ТРЕКИ У СВЕРНУТЫХ ПАПОК ПРИ СКРОЛЛЕ
                                      ------------------------------------------------
                             -- = 0 | DO NOT IGNORE TRACKS IN MINIMIZED FOLDERS WHEN SCROLLING
                             -- = 1 | IGNORE TRACKS IN MINIMIZED FOLDERS WHEN SCROLLING
                             ----------------------------------------------------------
    
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.3.2",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    if not Arc.SWS_API(true)then Arc.no_undo()return end;
    
    if not indent or type(indent)~= "number" then indent = 1 end;
    if indent >= 0 and indent <= 50 then indent = indent else indent = 1 end;
    
    local
    Script_Name = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    
    if not Arc.If_Equals(Script_Name,
                         "Archie_Track;  Move selected tracks down by one visible(`).lua",
                         "Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua",
                         "Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua" )then;
        reaper.MB("Rus:\n\n"..
                  " * Неверное имя скрипта !\n * Имя скрипта должно быть одно из следующих \n"..
                  "    в зависимости от задачи. \n\n\n"..
                  "Eng:\n\n * Invalid script name ! \n"..
                  " * The script name must be one of the following \n"..
                  "    depending on the task.\n"..
                  "-------\n\n\n"..
                  "Script Name: / Имя скрипта:\n\n"..
                  "   Archie_Track;  Move selected tracks down by one visible(`).lua \n\n"..
                  "   Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua \n\n"..
                  "   Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua",
                  "ERROR !",0);
        Arc.no_undo() return;
    end;
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    
    if Scroll ~= 1 and Scroll ~= 0 then Scroll = 0 end;
    
    
    reaper.PreventUIRefresh(1);
    
    
    local VisibTCPGuid = {};
    for i = reaper.CountSelectedTracks(0),1,-1 do; 
        local track = reaper.GetSelectedTrack(0,i-1);
        VisibTCPGuid[i] = reaper.GetTrackGUID(track);     
        local VisibTCP = reaper.IsTrackVisible(track,false);
        if not VisibTCP then;
            reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",0);
        end;
    end;
    
    
    local ScrollCheck, Fol_W, NumbTr_w, Undo,Fold_W, wind, block_request,Guid;
    do;-->-0.1
    
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then goto noSel end;
        
        
        reaper.Undo_BeginBlock();
        Undo = true;
        
        
        local GuidStr;
        Guid = {};
        for i = 1, reaper.CountSelectedTracks(0) do; 
            local track = reaper.GetSelectedTrack(0,i-1);        
            Guid[i] = reaper.GetTrackGUID(track);
            GuidStr = (GuidStr or "")..Guid[i];
        end;
        
        
        ---[#3]-----------------------------------------------------------------------------------
        local DummyTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1);
        local DummyFold = reaper.GetMediaTrackInfo_Value(DummyTrack,"I_FOLDERDEPTH");
        local DummyDepth = reaper.GetTrackDepth(DummyTrack);
        if DummyFold < 0 then DummyFold = DummyDepth-DummyDepth*2 end;
        reaper.SetMediaTrackInfo_Value(DummyTrack,"I_FOLDERDEPTH",DummyDepth-DummyDepth*2);
        reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
        local DummyDeleteTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1);
        if reaper.GetMediaTrackInfo_Value(DummyTrack,"I_SELECTED") == 1 then DummyTrack = nil end;
        ------------------------------------------------------------------------------------------
        
        
        
        
        
        for i = #Guid,1,-1 do;-->-1
            local TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,Guid[i]);
            reaper.SetOnlyTrackSelected(TrackByGUID);
            local Numb = reaper.GetMediaTrackInfo_Value(TrackByGUID,"IP_TRACKNUMBER");
            local Depth = reaper.GetTrackDepth(TrackByGUID);
            local Fold = reaper.GetMediaTrackInfo_Value(TrackByGUID,"I_FOLDERDEPTH");
            
            --------
            if Fold == 1 then;
                for i8 = Numb, reaper.CountTracks(0) do;
                    local Tr = reaper.GetTrack(0,i8);
                    local Dep = reaper.GetTrackDepth(Tr);
                    if Dep <= Depth then;
                        Numb = reaper.GetMediaTrackInfo_Value(Tr,"IP_TRACKNUMBER")-1;
                        break;
                    end;
                end;
            end;
            --------
            
            for i2 = Numb, reaper.CountTracks(0) do;-->-2
                local NextTrack = reaper.GetTrack(0,i2);
                if NextTrack then;-->-3
                    local VisibTCP = reaper.IsTrackVisible(NextTrack,false);
                    if VisibTCP then;-->-4
                        local NextDepth = reaper.GetTrackDepth(NextTrack);
                        local Fold = reaper.GetMediaTrackInfo_Value(NextTrack,"I_FOLDERDEPTH");
                        local NextNumb = reaper.GetMediaTrackInfo_Value(NextTrack,"IP_TRACKNUMBER");
                        ------------------------------------------------------
                        
                        
                        if Script_Name == "Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua" then;-->-3.21
                            
                            -->>--// Один запрос для всех треков перед папками //-->>--
                            if not wind then;-->-3.1
                                for i3 = #Guid,1,-1 do;-->-3.2
                                    local track_W = reaper.BR_GetMediaTrackByGUID(0,Guid[i3]);
                                    local Depth_W = reaper.GetTrackDepth(track_W);
                                    local Numb__W = reaper.GetMediaTrackInfo_Value(track_W,"IP_TRACKNUMBER");
                                    local Fold__W = reaper.GetMediaTrackInfo_Value(track_W,"I_FOLDERDEPTH");
                                    
                                    for i7 = Numb__W,reaper.CountTracks(0) do;-->-3.3
                                        local Track_W = reaper.GetTrack(0,i7);
                                        
                                        ----
                                        if Fold__W == 1 then;
                                            local Depth__F = reaper.GetTrackDepth(Track_W);
                                            if Depth__F <= Depth_W then;
                                                local Fold___F = reaper.GetMediaTrackInfo_Value(track_W,"I_FOLDERDEPTH");
                                                if Fold___F == 1 then;
                                                    block_request = 1;
                                                end;
                                            end;
                                        else;
                                            block_request = 1;
                                        end;
                                        
                                        if block_request then;--55
                                        ----
                                            
                                            if Track_W then;-->-3.4
                                                local VisibTCP_W = reaper.IsTrackVisible(Track_W,false);
                                                if VisibTCP_W then;-->-3.5
                                                    
                                                    local PostGUID_W = reaper.GetTrackGUID(Track_W):gsub("-","");
                                                    local Concurrence_Guid_W = string.match(GuidStr:gsub("-",""),PostGUID_W);
                                                    if not Concurrence_Guid_W then;-->-3.6
                                                        
                                                        local PostDepth_W = reaper.GetTrackDepth(Track_W);
                                                        local PostFold_W = reaper.GetMediaTrackInfo_Value(Track_W,"I_FOLDERDEPTH");
                                                        if PostDepth_W > Depth_W or PostFold_W == 1 then;
                                                            wind = true;
                                                            NumbTr_w = math.ceil(Numb__W)..", "..(NumbTr_w or "");
                                                        end;
                                                        break;--<-3.6
                                                    end;--<-3.6
                                                end;--<-3.5
                                            end;--<-3.4
                                        end;--55
                                    end;--<-3.3
                                end;--<-3.2
                                
                                
                                if wind then;
                                    NumbTr_w = NumbTr_w:reverse():gsub(",", "- ",1):reverse();
                                    local text_w = "Rus:\n * Поместить трек(и) № "..NumbTr_w.."в папку(и)\n\n"..
                                                   "Eng:\n * Put the track(s) № "..NumbTr_w.."in folder(s)";
                                    local MB = reaper.MB(text_w,"Move the selected track down one.",3);
                                    if MB == 6 then Fol_W = 0; elseif MB == 7 then Fol_W = 1; elseif MB == 2 then goto cancel end;
                                else;                      
                                    wind = true;
                                end;
                            end;--<-3.1          
                            if Fol_W then Fold = Fol_W end;
                            ---// ---<<-- запрос ---<<---- //---
                        end;-->-3.21
                        ------------
                        
                        
                        
                        
                        if Script_Name == "Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua" then;
                            if NextDepth > Depth then Fold = 1 end;
                        end;
                        
                        if Script_Name == "Archie_Track;  Move selected tracks down by one visible(`).lua" then;
                            if Fold == 1 then Fold = 0 end;
                        end;
                        
                        ScrollCheck = true;
                        
                        
                        if Fold ~= 1 then;-->-6
                            
                            if Fold < 0 then;
                                reaper.ReorderSelectedTracks(NextNumb,2);
                            else;
                                reaper.ReorderSelectedTracks(NextNumb,0);
                            end;
                            break;--<-2
                        else;--<->-6
                            
                            local x;
                            for i3 = NextNumb, reaper.CountTracks(0) do;
                                local NextTrack2 = reaper.GetTrack(0,i3);
                                if not NextTrack2 then; 
                                    NextTrack2 = reaper.GetTrack(0,reaper.CountTracks(0)-1);
                                    x = 1;
                                end;
                                if NextTrack2 then;
                                    local NextDepth2 = reaper.GetTrackDepth(NextTrack2);
                                    if NextDepth2 <= Depth then;
                                        local NextNumb2 = (reaper.GetMediaTrackInfo_Value(NextTrack2,"IP_TRACKNUMBER")-1);
                                        reaper.ReorderSelectedTracks(NextNumb2+(x or 0),0);
                                        x = nil;
                                        break;   
                                    end; 
                                end; 
                            end;
                            break;--<-6-/-<-2
                        end;--<-6
                    end;--<-4  
                end;--<-3 
            end;--<-2
        end;--<-1
        
        
        
       ::cancel::
        ---[#3]---------------------------------------------------------------------------
        reaper.DeleteTrack(DummyDeleteTrack);
        if reaper.GetTrack(0,reaper.CountTracks(0)-1) == DummyTrack then;
            reaper.SetMediaTrackInfo_Value(DummyTrack,"I_FOLDERDEPTH",DummyFold);
        end;
        ----------------------------------------------------------------------------------     
    
    
    end;--<-0.1
     
    ::noSel::
    for i = 1, #VisibTCPGuid do;
        local track = reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[i]);
        reaper.SetTrackSelected(track,1);
    end;
    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------
    
    
    
    reaper.PreventUIRefresh(-1);



    --------
    if Scroll == 1 then;-->-1
        if ScrollCheck then;-->-2
            reaper.PreventUIRefresh(2);
            local TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,Guid[#Guid]);
            reaper.SetOnlyTrackSelected(TrackByGUID);
            Arc.Action(40286,40285);--<--> Go to track
            ------------------
            if Ignore_superCollapse == 1 then;
                local stop;
                local NumbPostByG = reaper.GetMediaTrackInfo_Value(TrackByGUID,"IP_TRACKNUMBER");
                for i = NumbPostByG, reaper.CountTracks(0)-1 do;
                    local TrackScr = reaper.GetTrack(0,i);
                    if TrackScr then;
                        local height = reaper.GetMediaTrackInfo_Value(TrackScr,"I_WNDH");
                        if height < 24 then;
                            indent = indent +1;
                        end;
                        stop = (stop or 0)+1;
                        if stop == indent then break end;
                    end;
                end;
            end;
            ------------------
            for i = 1, indent do;
                Arc.Action(40285);--> Go to track
            end;
            reaper.SetOnlyTrackSelected(reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[1]));
            for i = 1, #VisibTCPGuid do;
                local track = reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[i]);
                reaper.SetTrackSelected(track,1);
            end;
            reaper.PreventUIRefresh(-2);
        end;--<-2
    end;--<-1 
    --------
    
    
    if Undo then;
        reaper.Undo_EndBlock(Script_Name:gsub("Archie_Track;  ","",1):gsub(".lua","",1),-1);
    else;
        Arc.no_undo();
    end;