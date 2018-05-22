unit Decklink;

interface


//  Видео режимы Decklink
const  bmdModeNTSC	       : integer = $6e747363;
const  bmdModeNTSC2398	   : integer = $6e743233;
const  bmdModePAL	         : integer = $70616c20;
const  bmdModeNTSCp	       : integer = $6e747370;
const  bmdModePALp	       : integer = $70616c70;
const  bmdModeHD1080p2398	 : integer = $32337073;
const  bmdModeHD1080p24	   : integer = $32347073;
const  bmdModeHD1080p25	   : integer = $48703235;
const  bmdModeHD1080p2997	 : integer = $48703239;
const  bmdModeHD1080p30	   : integer = $48703330;
const  bmdModeHD1080i50	   : integer = $48693530;
const  bmdModeHD1080i5994	 : integer = $48693539;
const  bmdModeHD1080i6000	 : integer = $48693630;
const  bmdModeHD1080p50	   : integer = $48703530;
const  bmdModeHD1080p5994	 : integer = $48703539;
const  bmdModeHD1080p6000	 : integer = $48703630;
const  bmdModeHD720p50	   : integer = $68703530;
const  bmdModeHD720p5994	 : integer = $68703539;
const  bmdModeHD720p60	   : integer = $68703630;
const  bmdMode2k2398	     : integer = $326b3233;
const  bmdMode2k24	       : integer = $326b3234;
const  bmdMode2k25	       : integer = $326b3235;
const  bmdMode2kDCI2398	   : integer = $32643233;
const  bmdMode2kDCI24	     : integer = $32643234;
const  bmdMode2kDCI25	     : integer = $32643235;
const  bmdMode4K2160p2398  : integer = $346b3233;
const  bmdMode4K2160p24	   : integer = $346b3234;
const  bmdMode4K2160p25	   : integer = $346b3235;
const  bmdMode4K2160p2997  : integer = $346b3239;
const  bmdMode4K2160p30	   : integer = $346b3330;
const  bmdMode4K2160p50	   : integer = $346b3530;
const  bmdMode4K2160p5994  : integer = $346b3539;
const  bmdMode4K2160p60	   : integer = $346b3630;
const  bmdMode4kDCI2398	   : integer = $34643233;
const  bmdMode4kDCI24	     : integer = $34643234;
const  bmdMode4kDCI25	     : integer = $34643235;
const  bmdModeUnknown	     : integer = $69756e6b;


//  Форматы пикселя Decklink
const  bmdFormat8BitYUV	    : integer = $32767579;
const  bmdFormat10BitYUV   	: integer = $76323130;
const  bmdFormat8BitARGB   	: integer = 32;
const  bmdFormat8BitBGRA   	: integer = $42475241;
const  bmdFormat10BitRGB   	: integer = $72323130;
const  bmdFormat12BitRGB	  : integer = $52313242;
const  bmdFormat12BitRGBLE	: integer = $5231324c;
const  bmdFormat10BitRGBXLE	: integer = $5231306c;
const  bmdFormat10BitRGBX	  : integer = $52313062;
const  bmdFormatH265	      : integer = $68657631;
const  bmdFormatDNxHR	      : integer = $41566468;


implementation

end.
