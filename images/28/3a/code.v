module wallace_tree_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] SUM  
);  
    wire [7:0] product0, product1, product2;  
    wire [4:0] partial_sum0, partial_sum1;  
    wire [4:0] carry0, carry1;  

    // Generate partial products  
    assign product0 = A * {1'b0, B};  
    assign product1 = A * {1'b0, C};  
    assign product2 = B * {1'b0, C};  

    // Add partial products using standard adder  
    assign partial_sum0 = product0[4:0] + product1[4:0];  
    assign carry0 = product0[5:4] + product1[5:4];  
    assign partial_sum1 = partial_sum0 + product2[4:0];  
    assign carry1 = carry0 + product2[5:5];  

    // Final sum  
    assign SUM = partial_sum1 + carry1;  

endmodule