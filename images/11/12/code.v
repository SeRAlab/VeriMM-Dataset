module chacha20_simple(input [31:0] key, input [31:0] nonce, output reg [31:0] output_data);  
    always @(key, nonce) begin  
        output_data = (key + nonce) ^ 32'hA5A5A5A5; // Simple operation for demonstration  
    end  
endmodule