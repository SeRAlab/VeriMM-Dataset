module array_multiplier (  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] partial_products [3:0];  
    wire [7:0] sum1, sum2, sum3;  
    wire [3:0] pp0, pp1, pp2, pp3;  
    assign pp0 = A & {4{B[0]}};  
    assign pp1 = A & {4{B[1]}} << 1;  
    assign pp2 = A & {4{B[2]}} << 2;  
    assign pp3 = A & {4{B[3]}} << 3;  
    assign partial_products[0] = pp0;  
    assign partial_products[1] = pp1;  
    assign partial_products[2] = pp2;  
    assign partial_products[3] = pp3;  
    assign sum1 = {4'b0000, partial_products[0]} + {3'b000, partial_products[1]};  
    assign sum2 = sum1 + {2'b00, partial_products[2]};  
    assign P = sum2 + {1'b0, partial_products[3]};  
endmodule