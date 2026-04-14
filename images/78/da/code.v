module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    input en,
    output [3:0] out
);wire [3:0] mux1, mux2;

assign mux1 = (sel[0] == 0) ? in0 : in1;
assign mux2 = (sel[0] == 0) ? in2 : in3;

assign out = (en == 1) ? ((sel[1] == 0) ? mux1 : mux2) : 4'b0;

endmodule