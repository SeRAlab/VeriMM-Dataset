module top_module(
    input [63:0] in0,
    input [63:0] in1,
    input sel,
    output [63:0] out
);

    // Assign the output based on the select signal
    assign out = sel ? in1 : in0;

endmodule