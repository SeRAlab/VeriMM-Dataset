module hmac #(parameter KEY_SIZE = 128, MESSAGE_SIZE = 128, HASH_SIZE = 128) (  
    input clk,  
    input [KEY_SIZE-1:0] key,  
    input [MESSAGE_SIZE-1:0] message,  
    output reg [HASH_SIZE-1:0] hmac_out  
);  

    reg [HASH_SIZE-1:0] inner_hash;  
    reg [HASH_SIZE-1:0] outer_hash;  

    always @(posedge clk) begin  
        // Simple hash function: XOR the key with the message  
        inner_hash <= key ^ message;  
        outer_hash <= key ^ inner_hash;  
        hmac_out <= outer_hash;  
    end  
endmodule