module top_module(
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out
);

    // Assign the output based on the select signal
    assign out = sel ? in1 : in0;

endmodule