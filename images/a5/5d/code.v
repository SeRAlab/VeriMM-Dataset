module top_module(
  input RomInexactRound,
  input SNnotDB,
  input AMCBit,
  input AM32,
  input AM3,
  input notAM31_3,
  input notAM2_0,
  output Inexact
);wire InexactSN;
  wire InexactDB;
  wire PostNormBy1SNBit;
  wire PostNormBy1DBBit;

  // Calculate InexactSN
  assign InexactSN = PostNormBy1SNBit | (notAM31_3 & notAM2_0) | (notAM31_3 & ~AM32 & ~AM3 & notAM2_0);

  // Calculate InexactDB
  assign InexactDB = PostNormBy1DBBit | notAM2_0;

  // Calculate internal signals
  assign PostNormBy1SNBit = (SNnotDB & ~AM32 & AMCBit) | (~SNnotDB & AM3 & AMCBit);
  assign PostNormBy1DBBit = notAM2_0 & AMCBit;

  // Calculate Inexact
  assign Inexact = (AM3 & AMCBit & ~SNnotDB) | (notAM2_0 & ~SNnotDB & AM32 & AMCBit) | (notAM31_3 & ~SNnotDB) | InexactSN | InexactDB | (RomInexactRound & (InexactSN | InexactDB));

endmodule