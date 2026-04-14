module HMAC (  
    input [7:0] key,  
    input [7:0] message,  
    output reg [7:0] hmac  
);  
    always @(key or message) begin  
        hmac = key ^ message; // Simple XOR as a hash function  
    end  
endmodule