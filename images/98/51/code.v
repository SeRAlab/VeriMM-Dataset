module top_module(
    AL,
    MonitorRom,
    ACIA,
    KeyBoardPort,
    VideoMem,
    BasicRom,
    Ram
);input [15:0] AL;
output MonitorRom;
wire MonitorRom;
output ACIA;
wire ACIA;
output KeyBoardPort;
wire KeyBoardPort;
output VideoMem;
wire VideoMem;
output BasicRom;
wire BasicRom;
output Ram;
wire Ram;







assign MonitorRom = ((63488 <= AL) && (AL <= 65535));
assign ACIA = ((61440 <= AL) && (AL <= 63487));
assign KeyBoardPort = ((56320 <= AL) && (AL <= 57343));
assign VideoMem = ((53248 <= AL) && (AL <= 54271));
assign BasicRom = ((40960 <= AL) && (AL <= 49151));
assign Ram = ((0 <= AL) && (AL <= 8191));

endmodule