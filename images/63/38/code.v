module top_module(
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1,
    output reg X
);wire SA, SB, SC, SD, SE, SF, SG, SH;

assign SA = A0 & ~S0 & ~S1;
assign SB = A1 & S0 & ~S1;
assign SC = A2 & ~S0 & S1;
assign SD = A3 & S0 & S1;

assign SE = SA | SB;
assign SF = SC | SD;

assign SG = SE & ~S1;
assign SH = SF & S1;

assign X = SG | SH;

endmodule