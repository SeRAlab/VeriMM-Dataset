module adder_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    output [15:0] SUM,  
    output COUT  
);  
    wire [16:0] temp_sum;  
    assign temp_sum = {1'b0, A} + {1'b0, B};  
    assign SUM = temp_sum[15:0];  
    assign COUT = temp_sum[16];  
endmodule