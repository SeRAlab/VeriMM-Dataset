module top_module(
    input A,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    input clk,
    output Y
);wire inv1_out, inv2_out, inv3_out;

assign inv1_out = ~A;
assign inv2_out = ~inv1_out;
assign inv3_out = ~inv2_out;

assign Y = inv3_out;

endmodule