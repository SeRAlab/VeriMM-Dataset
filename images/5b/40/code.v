module top_module(
    input A0,
    input A1,
    input A2,
    input A3,
    input [1:0] S,
    output X,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire sel0, sel1;

assign sel0 = (S == 2'b00) ? 1'b1 : 1'b0;
assign sel1 = (S == 2'b01) ? 1'b1 : 1'b0;

assign X = (sel1 & A1) | (sel0 & A0) | ((~sel0 & ~sel1) & ((S == 2'b10) ? A2 : A3));

endmodule