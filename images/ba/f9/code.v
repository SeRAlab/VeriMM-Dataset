module top_module(
    input [7:0] TX_ADR,
    input [22:0] TX_DAT,
    input TX_OK,
    input [7:0] RX_ADR,
    input [22:0] RX_DAT,
    input RX_OK,
    input [1:0] SW,

    output [15:0] DATA
);assign DATA = (SW == 0) ? {TX_DAT[7:0], TX_ADR} :
    (SW == 1) ? {1'b0, TX_DAT[22:8]} :
    (SW == 2) ? {RX_DAT[7:0], RX_ADR[7:0]} :
    {1'b0, RX_DAT[22:8]};endmodule