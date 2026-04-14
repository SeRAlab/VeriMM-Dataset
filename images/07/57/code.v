module array_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial_products[3:0];
    wire [7:0] sum[2:0];

    // Generate partial products
    assign partial_products[0] = A & {4{B[0]}};
    assign partial_products[1] = A & {4{B[1]}};
    assign partial_products[2] = A & {4{B[2]}};
    assign partial_products[3] = A & {4{B[3]}};

    // Shift partial products
    assign sum[0] = {4'b0, partial_products[0]};
    assign sum[1] = {3'b0, partial_products[1], 1'b0};
    assign sum[2] = {2'b0, partial_products[2], 2'b0};
    
    // Add partial products
    assign P = sum[0] + sum[1] + sum[2] + {partial_products[3], 4'b0};

endmodule