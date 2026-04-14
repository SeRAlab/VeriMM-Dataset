module top_module(
    input [7:0] Multiplicand,
    input [7:0] Multiplier,

    output [15:0] Product
);assign Product = Multiplicand * Multiplier;

endmodule