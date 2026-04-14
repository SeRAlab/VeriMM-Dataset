module top_module(in0, in1, ctrl, out);input [3:0] in0;
    input [3:0] in1;
    input ctrl;
    output [3:0] out;

    wire [1:0] sel;
    assign sel = {ctrl, ~ctrl};

    assign out[0] = in0[0] & sel[0] | in1[0] & sel[1];
    assign out[1] = in0[1] & sel[0] | in1[1] & sel[1];
    assign out[2] = in0[2] & sel[0] | in1[2] & sel[1];
    assign out[3] = in0[3] & sel[0] | in1[3] & sel[1];
endmodule