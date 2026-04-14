module top_module(
    input [15:0] in0,
    input [15:0] in1,
    input sel,
    output [15:0] out
);

    // Assign the output based on the select signal
    assign out = sel ? in1 : in0;

endmodule