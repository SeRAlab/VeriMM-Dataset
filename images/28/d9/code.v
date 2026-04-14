module hmac_simple (  
    input [7:0] key,  
    input [7:0] message,  
    output [7:0] hmac  
);  
    assign hmac = key ^ message; // Simple HMAC using XOR as the hash function  
endmodule