module top_module(
    in1,
    in2,
    out,
    VPWR,
    VGND,
    VPB,
    VNB
);input [3:0] in1;
input [3:0] in2;
output [3:0] out;
input VPWR, VGND, VPB, VNB;

wire [3:0] not_in1;
wire [3:0] not_in2;

// invert the inputs
assign not_in1 = ~in1;
assign not_in2 = ~in2;

// perform the AND operation directly instead of using OR-NOR
assign out = not_in1 & not_in2;

endmodule