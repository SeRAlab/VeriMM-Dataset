module top_module(
    sel,
    in0,
    in1,
    in2,
    in3,
    out
);input [1:0] sel;
input in0;
input in1;
input in2;
input in3;
output out;

wire sel0;
wire sel1;

assign sel0 = ~sel[1] & ~sel[0];
assign sel1 = ~sel[1] & sel[0];

assign out = (sel0 & in0) | (sel1 & in1) | (sel0 & in2) | (sel1 & in3);

endmodule