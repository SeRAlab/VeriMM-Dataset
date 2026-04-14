module top_module(
    // Inputs
    input        reset,
    input  [1:0] sel,
    input  [3:0] in0,
    input  [3:0] in1,
    input  [3:0] in2,
    input  [3:0] in3,

    // Outputs
    output [3:0] out
);assign out = reset ? 4'b0000 : (sel == 2'b00 ? in0 : sel == 2'b01 ? in1 : sel == 2'b10 ? in2 : in3);

endmodule