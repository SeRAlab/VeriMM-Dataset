module wallace_tree_multiplier (  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [15:0] partial_products;  
    wire [7:0] sum[0:3];  
    wire [4:0] carry[0:3];  

    // Generate partial products  
    assign partial_products = {4{A}} & {4{B}};  

    // Level 1 Reduction  
    assign sum[0] = partial_products[0] + {3'b0, partial_products[4]} + {2'b0, partial_products[8]} + {1'b0, partial_products[12]};  
    assign carry[0] = (partial_products[0] & {3'b0, partial_products[4]}) + ({2'b0, partial_products[8]} & {1'b0, partial_products[12]});  

    // Level 2 Reduction  
    assign sum[1] = sum[0] + carry[0];  
    assign carry[1] = (sum[0] & carry[0]);  

    // Level 3 Reduction  
    assign sum[2] = sum[1] + carry[1];  
    assign carry[2] = (sum[1] & carry[1]);  
    assign P = sum[2] + carry[2];  
endmodule