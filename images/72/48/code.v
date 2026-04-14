module top_module(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);wire [2:0] or_bitwise;
    wire or_logical;
    wire [2:0] not_a;
    wire [2:0] not_b;

    // Bitwise OR operation using multiplexers
    assign or_bitwise[0] = (a[0] | b[0]) ? 1'b1 : 1'b0;
    assign or_bitwise[1] = (a[1] | b[1]) ? 1'b1 : 1'b0;
    assign or_bitwise[2] = (a[2] | b[2]) ? 1'b1 : 1'b0;

    // Logical OR operation using multiplexers
    assign or_logical = (or_bitwise[0] | or_bitwise[1] | or_bitwise[2]) ? 1'b1 : 1'b0;

    // NOT operation using inverters
    assign not_a[0] = ~a[0];
    assign not_a[1] = ~a[1];
    assign not_a[2] = ~a[2];
    assign not_b[0] = ~b[0];
    assign not_b[1] = ~b[1];
    assign not_b[2] = ~b[2];

    // Concatenate NOT outputs to form 6-bit output
    assign out_not = {not_a, not_b};

    // Assign outputs
    assign out_or_bitwise = or_bitwise;
    assign out_or_logical = or_logical;

endmodule