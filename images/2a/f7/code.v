module adder_64bit(  
    input [63:0] A,  
    input [63:0] B,  
    output [63:0] Sum,  
    output Overflow  
);  
    wire [64:0] full_sum;  
    assign full_sum = {1'b0, A} + {1'b0, B};  
    assign Sum = full_sum[63:0];  
    assign Overflow = full_sum[64];  
endmodule