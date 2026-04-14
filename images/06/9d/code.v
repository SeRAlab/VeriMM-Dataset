module adder_32bit (  
    input [31:0] a,  
    input [31:0] b,  
    output [31:0] sum,  
    output overflow  
);  
    wire [32:0] full_sum;  
    assign full_sum = {1'b0, a} + {1'b0, b};  
    assign sum = full_sum[31:0];  
    assign overflow = full_sum[32] ^ full_sum[31];  
endmodule