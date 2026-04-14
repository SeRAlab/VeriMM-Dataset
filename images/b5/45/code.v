module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input sel,
    output [3:0] out
);

    // Assign the output based on the select signal
    assign out = (sel == 1'b0) ? in0 : in1;

endmodule