module top_module(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output [3:0] out_final
);// Bitwise-OR Module
    wire [2:0] bitwise_or;
    assign bitwise_or = a | b;
    assign out_or_bitwise = bitwise_or;

    // Logical-OR Module
    wire logical_or;
    assign logical_or = (a[0] | b[0]) | (a[1] | b[1]) | (a[2] | b[2]);
    assign out_or_logical = logical_or;

    // NOT Module for a and b
    wire [2:0] not_a;
    wire [2:0] not_b;
    assign not_a = ~a;
    assign not_b = ~b;
    assign out_not = {not_b, not_a};

    // Adder Module
    wire [3:0] adder_input;
    assign adder_input = {bitwise_or, logical_or};
    assign out_final = adder_input;

endmodule