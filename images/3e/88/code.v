module hmac_simple (  
    input [7:0] key,  
    input [7:0] message,  
    output [7:0] hmac_out  
);  
    // Simple hash function using XOR  
    assign hmac_out = key ^ message;  
endmodule