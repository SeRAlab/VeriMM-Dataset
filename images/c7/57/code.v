module add_subtract (
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] result
);

    wire [7:0] sum;
    wire [7:0] diff;

    assign sum = a + b;
    assign diff = a - b;

    assign result = sel ? diff : sum;

endmodule