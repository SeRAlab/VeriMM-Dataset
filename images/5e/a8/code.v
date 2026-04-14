module multiplier_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [31:0] product
);

    wire [7:0] prod0, prod1, prod2, prod3;
    wire [15:0] partial0, partial1, partial2, partial3;

    multiplier4 multiplier4_inst0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .product(prod0)
    );

    multiplier4 multiplier4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .product(prod1)
    );

    multiplier4 multiplier4_inst2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .product(prod2)
    );

    multiplier4 multiplier4_inst3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .product(prod3)
    );

    assign partial0 = {8'b0, prod0};
    assign partial1 = {prod1, 8'b0};
    assign partial2 = {8'b0, prod2};
    assign partial3 = {prod3, 8'b0};

    assign product = partial0 + partial1 + partial2 + partial3;

endmodule

module multiplier4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] product
);
    assign product = a * b;
endmodule