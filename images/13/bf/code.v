module wallace_tree_multiplier(  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [7:0] partial_products [3:0];  
    wire [7:0] sum1, sum2, carry1, carry2;  

    assign partial_products[0] = {4'b0000, A & {4{B[0]}}};  
    assign partial_products[1] = {3'b000, A & {4{B[1]}}, 1'b0};  
    assign partial_products[2] = {2'b00, A & {4{B[2]}}, 2'b00};  
    assign partial_products[3] = {1'b0, A & {4{B[3]}}, 3'b000};  

    // Level 1 of Wallace tree: Summing partial products
    assign sum1 = partial_products[0] + partial_products[1];  
    assign carry1 = partial_products[2] + partial_products[3];  

    // Level 2: Final summation
    assign P = sum1 + carry1;  

endmodule