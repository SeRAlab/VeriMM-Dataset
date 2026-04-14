module chacha20_simplified(  
    input [31:0] key,  
    input [31:0] nonce,  
    output reg [31:0] output_data  
);  
    always @(key, nonce) begin  
        output_data = key + nonce;  
    end  
endmodule