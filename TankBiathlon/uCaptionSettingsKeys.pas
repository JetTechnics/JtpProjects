unit uCaptionSettingsKeys;

interface

const
  iStringsNum = 8;
  iCaptionsNum = 4;
  iTanksNum = 4;

const
  sStringsSect: string = 'Strings';
  sStringN: string = 'string_';
  sStringEmpty: string = 'Empty';

  sCaptionsSectN: string = 'Captions_';
  asCaptionParams: array[1..13] of string =
    ('Team_name', 'GPS_id', 'Color', 'Name1', 'Name2', 'Name3',
     'Targets_hit', 'Penalty_laps', 'Penalty_stops',
     'Lap', 'Speed', 'Speed_max', 'Speed_ave');

implementation

end.
