module aes_encrypt (  
    input [7:0] plaintext,  
    input [7:0] key,  
    input clk,  
    input rst,  
    output reg [7:0] ciphertext  
);  
  
    reg [7:0] state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            ciphertext <= 8'b0;  
        end else begin  
            // Simplified AES transformation  
            state <= plaintext ^ key;  // AddRoundKey  
            // Here we would normally perform the S-box and shift rows, etc.  
            ciphertext <= state;  // Final output  
        end  
    end  
endmodule