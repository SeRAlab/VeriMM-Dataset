module top_module(A, B, sum, difference, product, quotient);input [7:0] A;
    input [7:0] B;
    output [7:0] sum;
    output [7:0] difference;
    output [15:0] product;
    output [7:0] quotient;
    
    wire [7:0] A_2s_comp;
    wire [7:0] B_2s_comp;
    wire [15:0] product_2s_comp;
    
    assign A_2s_comp = (~A) + 1;
    assign B_2s_comp = (~B) + 1;
    assign product_2s_comp = A_2s_comp * B_2s_comp;
    
    assign sum = A + B;
    assign difference = A + B_2s_comp;
    assign product = (~product_2s_comp) + 1;
    assign quotient = (~((A_2s_comp / B_2s_comp) - 1)) + 1;
endmodule