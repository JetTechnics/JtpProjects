object _GPS_dm: T_GPS_dm
  OldCreateOrder = False
  Height = 545
  Width = 709
  object qImportColor: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GroupID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'ColorImg'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'ColorID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'insert into tblColor'
      '(GroupID, ColorImg, ColorID)'
      'values(:GroupID, :ColorImg, :ColorID)'
      ''
      '')
    Left = 488
    Top = 161
  end
  object qImportSource: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  from  tblMesheny'
      '')
    Left = 208
    Top = 161
  end
  object qImportMesheny: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GroupID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'MeshenyName'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'MeshenyCount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'MeshenyID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'insert into tblMesheny'
      '(GroupID, MeshenyName, MeshenyCount, MeshenyID)'
      'values(:GroupID, :MeshenyName, :MeshenyCount, :MeshenyID)'
      ''
      '')
    Left = 576
    Top = 161
  end
  object qColor_Get: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'ColorID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *  from  tblColor '
      'where  ColorID =:ColorID')
    Left = 536
    Top = 25
    object AutoIncField1: TAutoIncField
      FieldName = 'tblColorID'
      ReadOnly = True
    end
    object WideStringField1: TWideStringField
      FieldName = 'GroupID'
      Size = 30
    end
    object WideStringField2: TWideStringField
      FieldName = 'ColorImg'
      Size = 100
    end
    object WideStringField3: TWideStringField
      FieldName = 'ColorID'
      Size = 100
    end
    object WideStringField4: TWideStringField
      FieldName = 'TexturePath'
      Size = 255
    end
    object WideStringField5: TWideStringField
      FieldName = 'PicturePath'
      Size = 255
    end
    object IntegerField1: TIntegerField
      FieldName = 'ColorValue'
    end
  end
  object qCountry_Get: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CountryName'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *  from  tblCountry '
      'where  CountryName =:CountryName '
      '')
    Left = 608
    Top = 25
  end
  object qTmp: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <>
    Left = 392
    Top = 25
  end
  object qMesheny_Get: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'MeshenyID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *  from  tblMesheny'
      'where  MeshenyID =:MeshenyID'
      '')
    Left = 456
    Top = 25
    object AutoIncField2: TAutoIncField
      FieldName = 'tblMeshenyID'
      ReadOnly = True
    end
    object WideStringField6: TWideStringField
      FieldName = 'GroupID'
      Size = 30
    end
    object WideStringField7: TWideStringField
      FieldName = 'MeshenyName'
      Size = 100
    end
    object WideStringField8: TWideStringField
      FieldName = 'MeshenyObject'
      Size = 100
    end
    object WideStringField9: TWideStringField
      FieldName = 'MeshenyCount'
      Size = 100
    end
    object WideStringField10: TWideStringField
      FieldName = 'MeshenyTryMain'
      Size = 100
    end
    object WideStringField11: TWideStringField
      FieldName = 'MeshenyCountMain'
      Size = 100
    end
    object WideStringField12: TWideStringField
      FieldName = 'MeshenyTryOther'
      Size = 100
    end
    object WideStringField13: TWideStringField
      FieldName = 'MeshenyCountOther'
      Size = 100
    end
    object WideStringField14: TWideStringField
      FieldName = 'MeshenyID'
      Size = 100
    end
    object WideStringField15: TWideStringField
      FieldName = 'PicturePath'
      Size = 255
    end
  end
  object qTankForColor: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'TeamColorID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *  from  tblAmplya a'
      'RIGHT JOIN'
      '('
      
        'select * from ( select *  from  tblTeamPlayers tp, tblPlayers p ' +
        'where tp.TeamPlayer = p.PlayerID ) s2'
      'RIGHT JOIN'
      '('
      'select *  from  tblCountry c'
      'RIGHT JOIN'
      '('
      'select  t.GroupID as CID , t.TeamID  as TID, *'
      'from  tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'and t.TeamColorID =:TeamColorID '
      ') s1'
      'ON c.CountryName = s1.CID'
      ') s21'
      'ON s21.TID = s2.TeamID'
      ') s3'
      'ON s3.AmplyaID = a.AmplyaID'
      ''
      'order by a.AmplyaName'
      '')
    Left = 208
    Top = 17
  end
  object qTeamInZaezd: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *'
      'from tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'order by zm.NumTank, t.TeamName')
    Left = 104
    Top = 113
  end
  object qOtsechkiForTeam: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GPSID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *'
      
        'from tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t, tblOtse' +
        'ch o'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'and z.ZaezdID = o.GroupID'
      'and t.TeamID = o.TeamID'
      'and GPSID =:GPSID'
      'order by  o.NumOtsec')
    Left = 208
    Top = 65
  end
  object qUpdateGPS: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GPSID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'tblZaezdMapID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'update  tblZaezdMap '
      'set GPSID =:GPSID'
      'where tblZaezdMapID =:tblZaezdMapID'
      ''
      ''
      '')
    Left = 208
    Top = 113
    object AutoIncField3: TAutoIncField
      FieldName = 'tblStateID'
      ReadOnly = True
    end
    object WideStringField16: TWideStringField
      FieldName = 's.GroupID'
      Size = 30
    end
    object WideStringField17: TWideStringField
      FieldName = 'StateName'
      Size = 100
    end
    object WideStringField18: TWideStringField
      FieldName = 'StateID'
      Size = 100
    end
    object WideStringField19: TWideStringField
      FieldName = 'ActiveState'
      Size = 100
    end
    object AutoIncField4: TAutoIncField
      FieldName = 'tblZaezdID'
      ReadOnly = True
    end
    object WideStringField20: TWideStringField
      FieldName = 'z.GroupID'
      Size = 30
    end
    object WideStringField21: TWideStringField
      FieldName = 'ZaezdName'
      Size = 100
    end
    object WideStringField22: TWideStringField
      FieldName = 'ZaezdID'
      Size = 100
    end
    object WideStringField23: TWideStringField
      FieldName = 'ActiveZaezd'
      Size = 200
    end
    object AutoIncField5: TAutoIncField
      FieldName = 'tblTeamsID'
      ReadOnly = True
    end
    object WideStringField24: TWideStringField
      FieldName = 't.GroupID'
      Size = 30
    end
    object WideStringField25: TWideStringField
      FieldName = 'TeamName'
      Size = 100
    end
    object WideStringField26: TWideStringField
      FieldName = 'Ekipag'
      Size = 100
    end
    object WideStringField27: TWideStringField
      FieldName = 't.TeamColorID'
      Size = 100
    end
    object WideStringField28: TWideStringField
      FieldName = 't.TeamID'
      Size = 100
    end
    object AutoIncField6: TAutoIncField
      FieldName = 'tblOtsechID'
      ReadOnly = True
    end
    object WideStringField29: TWideStringField
      FieldName = 'o.GroupID'
      Size = 30
    end
    object WideStringField30: TWideStringField
      FieldName = 'o.TeamID'
      Size = 100
    end
    object WideStringField31: TWideStringField
      FieldName = 'NumOtsec'
      Size = 100
    end
    object WideStringField32: TWideStringField
      FieldName = 'TimeOtsec'
      Size = 100
    end
    object WideStringField33: TWideStringField
      FieldName = 'DisplayPos'
      Size = 200
    end
    object WideStringField34: TWideStringField
      FieldName = 'tmsec'
      Size = 200
    end
    object WideStringField35: TWideStringField
      FieldName = 'o.TeamColorID'
      Size = 200
    end
    object WideStringField36: TWideStringField
      FieldName = 'Zaezd'
      Size = 200
    end
    object StringField1: TStringField
      FieldKind = fkCalculated
      FieldName = 'cTimeMS'
      Calculated = True
    end
  end
  object qTankPlayersForTeam: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GPSID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *  from  tblAmplya a'
      'RIGHT JOIN'
      '('
      
        'select * from ( select *  from  tblTeamPlayers tp, tblPlayers p ' +
        'where tp.TeamPlayer = p.PlayerID ) s2'
      'RIGHT JOIN'
      '('
      'select *  from  tblCountry c'
      'RIGHT JOIN'
      '('
      'select  t.GroupID as CID , t.TeamID  as TID, *'
      'from  tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'and GPSID =:GPSID'
      ') s1'
      'ON c.CountryName = s1.CID'
      ') s21'
      'ON s21.TID = s2.TeamID'
      ') s3'
      'ON s3.AmplyaID = a.AmplyaID'
      ''
      'order by a.DisplayPos'
      '')
    Left = 104
    Top = 17
  end
  object DBTanks: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\_TankBiathlon201' +
      '8\Tank_BASE\Tank_2013.mdb;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 16
    Top = 16
  end
  object DBLocal: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\_Tanks_13\Tank_B' +
      'ASE\Tank_GPS_LocalData.mdb;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 328
    Top = 16
  end
  object qInfoForTeam: TADOQuery
    Connection = DBTanks
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GPSID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'select *'
      
        'from tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t, tblInfo' +
        '1  i'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'and t.TeamID = i.TeamID'
      'and GPSID =:GPSID')
    Left = 104
    Top = 64
  end
  object qImportCountry: TADOQuery
    Connection = DBLocal
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GroupID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'CountryName'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'insert into tblCountry'
      '(GroupID, CountryName)'
      'values(:GroupID, :CountryName)'
      ''
      '')
    Left = 400
    Top = 160
  end
end
