module HMAC (  
    input wire [63:0] key,  
    input wire [63:0] message,  
    output reg [63:0] hmac  
);  
    reg [63:0] inner_hash;  
    reg [63:0] outer_hash;  
    
    always @(*) begin  
        // Simple hash function: XOR key and message  
        inner_hash = key ^ message;  
        outer_hash = inner_hash ^ key;  // Simplified outer hash  
        hmac = outer_hash;  
    end  
endmodule