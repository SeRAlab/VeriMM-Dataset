module hmac_example (  
    input [63:0] key,  
    input [63:0] message,  
    output [63:0] hmac_output  
);  
    wire [63:0] xor_result;  
    assign xor_result = key ^ message;  
    assign hmac_output = ~xor_result;  
endmodule