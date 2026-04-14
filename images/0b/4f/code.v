module wallace_tree_adder (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [4:0] sum
);
    wire [7:0] partial_products;
    wire [4:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products
    assign partial_products = {a[3] & b[3], a[3] & b[2], a[3] & b[1], a[3] & b[0],
                                a[2] & b[3], a[2] & b[2], a[2] & b[1], a[2] & b[0],
                                a[1] & b[3], a[1] & b[2], a[1] & b[1], a[1] & b[0],
                                a[0] & b[3], a[0] & b[2], a[0] & b[1], a[0] & b[0]};

    // First stage of addition
    assign {carry1, sum1} = partial_products[3:0] + partial_products[7:4] + c;

    // Second stage of addition
    assign {carry2, sum2} = sum1 + {carry1, 1'b0}; // Adjusting for carry

    // Final sum output
    assign sum = sum2 + carry2;

endmodule