module add_sub (
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] Q
);

    wire [3:0] sum;
    wire [3:0] diff;

    assign sum = A + B;
    assign diff = A - B;

    assign Q = SUB ? diff : sum;

endmodule