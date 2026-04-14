module top_module(
    output Y,
    input  A,
    input  B,
    input  C,
    input  D
);wire n1, n2, n3;

    // Using native Verilog NOR logic instead of unknown modules
    assign n1 = ~(A | B | C | ~D); // NOR4 behavior with D inverted
    assign n2 = ~(n1 | 1'b1 | 1'b1 | 1'b1); // This simplifies to ~1 => 0
    assign n3 = ~(n2 | 1'b1 | 1'b1 | 1'b1); // This simplifies to ~1 => 0
    assign Y = ~(n3 | 1'b1 | 1'b1 | 1'b1); // This simplifies to ~1 => 0

endmodule