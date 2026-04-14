module multiplier_64bit (
    input wire [63:0] a,
    input wire [63:0] b,
    output wire [127:0] product
);

    wire [63:0] product1, product2, product3, product4;
    wire [63:0] partial1, partial2, partial3, partial4;

    multiplier_32bit multiplier_32bit_inst1 (
        .a(a[63:32]),
        .b(b[63:32]),
        .product(product1)
    );

    multiplier_32bit multiplier_32bit_inst2 (
        .a(a[63:32]),
        .b(b[31:0]),
        .product(product2)
    );

    multiplier_32bit multiplier_32bit_inst3 (
        .a(a[31:0]),
        .b(b[63:32]),
        .product(product3)
    );

    multiplier_32bit multiplier_32bit_inst4 (
        .a(a[31:0]),
        .b(b[31:0]),
        .product(product4)
    );

    assign partial1 = {product1, 64'b0};
    assign partial2 = {32'b0, product2, 32'b0};
    assign partial3 = {32'b0, product3, 32'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [63:0] product
);

    wire [31:0] product1, product2, product3, product4;
    wire [31:0] partial1, partial2, partial3, partial4;

    multiplier_16bit multiplier_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .product(product1)
    );

    multiplier_16bit multiplier_16bit_inst2 (
        .a(a[31:16]),
        .b(b[15:0]),
        .product(product2)
    );

    multiplier_16bit multiplier_16bit_inst3 (
        .a(a[15:0]),
        .b(b[31:16]),
        .product(product3)
    );

    multiplier_16bit multiplier_16bit_inst4 (
        .a(a[15:0]),
        .b(b[15:0]),
        .product(product4)
    );

    assign partial1 = {product1, 32'b0};
    assign partial2 = {16'b0, product2, 16'b0};
    assign partial3 = {16'b0, product3, 16'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [31:0] product
);

    wire [15:0] product1, product2, product3, product4;
    wire [15:0] partial1, partial2, partial3, partial4;

    multiplier_8bit multiplier_8bit_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .product(product1)
    );

    multiplier_8bit multiplier_8bit_inst2 (
        .a(a[15:8]),
        .b(b[7:0]),
        .product(product2)
    );

    multiplier_8bit multiplier_8bit_inst3 (
        .a(a[7:0]),
        .b(b[15:8]),
        .product(product3)
    );

    multiplier_8bit multiplier_8bit_inst4 (
        .a(a[7:0]),
        .b(b[7:0]),
        .product(product4)
    );

    assign partial1 = {product1, 16'b0};
    assign partial2 = {8'b0, product2, 8'b0};
    assign partial3 = {8'b0, product3, 8'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] product
);

    wire [7:0] product1, product2, product3, product4;
    wire [7:0] partial1, partial2, partial3, partial4;

    multiplier_4bit multiplier_4bit_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .product(product1)
    );

    multiplier_4bit multiplier_4bit_inst2 (
        .a(a[7:4]),
        .b(b[3:0]),
        .product(product2)
    );

    multiplier_4bit multiplier_4bit_inst3 (
        .a(a[3:0]),
        .b(b[7:4]),
        .product(product3)
    );

    multiplier_4bit multiplier_4bit_inst4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .product(product4)
    );

    assign partial1 = {product1, 8'b0};
    assign partial2 = {4'b0, product2, 4'b0};
    assign partial3 = {4'b0, product3, 4'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] product
);

    wire [3:0] product1, product2, product3, product4;
    wire [3:0] partial1, partial2, partial3, partial4;

    multiplier_2bit multiplier_2bit_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .product(product1)
    );

    multiplier_2bit multiplier_2bit_inst2 (
        .a(a[3:2]),
        .b(b[1:0]),
        .product(product2)
    );

    multiplier_2bit multiplier_2bit_inst3 (
        .a(a[1:0]),
        .b(b[3:2]),
        .product(product3)
    );

    multiplier_2bit multiplier_2bit_inst4 (
        .a(a[1:0]),
        .b(b[1:0]),
        .product(product4)
    );

    assign partial1 = {product1, 4'b0};
    assign partial2 = {2'b0, product2, 2'b0};
    assign partial3 = {2'b0, product3, 2'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [3:0] product
);

    wire [1:0] product1, product2, product3, product4;
    wire [1:0] partial1, partial2, partial3, partial4;

    multiplier_1bit multiplier_1bit_inst1 (
        .a(a[1]),
        .b(b[1]),
        .product(product1)
    );

    multiplier_1bit multiplier_1bit_inst2 (
        .a(a[1]),
        .b(b[0]),
        .product(product2)
    );

    multiplier_1bit multiplier_1bit_inst3 (
        .a(a[0]),
        .b(b[1]),
        .product(product3)
    );

    multiplier_1bit multiplier_1bit_inst4 (
        .a(a[0]),
        .b(b[0]),
        .product(product4)
    );

    assign partial1 = {product1, 2'b0};
    assign partial2 = {1'b0, product2, 1'b0};
    assign partial3 = {1'b0, product3, 1'b0};
    assign partial4 = product4;

    assign product = partial1 + partial2 + partial3 + partial4;

endmodule

module multiplier_1bit (
    input wire a,
    input wire b,
    output wire product
);

    assign product = a & b;

endmodule