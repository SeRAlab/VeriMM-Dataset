module array_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial_products [3:0];
    
    // Generate partial products
    assign partial_products[0] = A & {4{B[0]}};
    assign partial_products[1] = A & {4{B[1]}};
    assign partial_products[2] = A & {4{B[2]}};
    assign partial_products[3] = A & {4{B[3]}};

    // Align the partial products
    assign P = {partial_products[3], 2'b00} + 
               {partial_products[2], 1'b0} + 
               partial_products[1] + 
               partial_products[0];
endmodule