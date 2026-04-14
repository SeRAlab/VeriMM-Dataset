module aes_8bit(  
    input [7:0] plaintext,  
    input [7:0] key,  
    input clk,  
    input rst,  
    output reg [7:0] ciphertext  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple AES operation (for illustration purposes, this doesn't represent actual AES)  
            ciphertext <= (plaintext ^ key) + 8'h1;  
        end  
    end  
endmodule