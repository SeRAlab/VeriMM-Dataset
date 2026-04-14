module chacha20_simple(  
    input [31:0] key,  
    input [31:0] nonce,  
    input [31:0] counter,  
    output reg [31:0] output_data  
);  
    always @(key, nonce, counter) begin  
        output_data = (key ^ nonce) + counter;  
    end  
endmodule