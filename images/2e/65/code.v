module aes_8bit (  
    input clk,  
    input rst,  
    input [7:0] plaintext,  
    input [7:0] key,  
    output reg [7:0] ciphertext  
);  

    // Simple Substitution Box (S-Box) for AES (example values)  
    reg [7:0] sbox [0:255];  
    
    initial begin  
        // Initialize the S-Box with some values (this is a placeholder)  
        sbox[8'h00] = 8'h63;  
        sbox[8'h01] = 8'h7c;  
        // ... fill in the rest of the S-Box ...  
        sbox[8'hff] = 8'h16;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
        end else begin  
            ciphertext <= sbox[plaintext ^ key]; // Simple xor and S-box substitution  
        end  
    end  
endmodule