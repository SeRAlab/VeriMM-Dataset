module top_module(a,b,c,sum);input [15:0] a,b;
    input [15:0] c;
    output [15:0] sum;

    
    assign sum = a ^ b ^ c;endmodule