module chacha_simple (  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    input wire [31:0] block_index,  
    output reg [31:0] keystream  
);  
    always @(key, nonce, block_index) begin  
        keystream = (key + nonce + block_index) % 32'hFFFFFFFF;  
    end  
endmodule