module multiplier2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [3:0] product
);

    assign product = a * b;

endmodule