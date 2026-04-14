module aes_encryption (  
    input clk,  
    input [3:0] plaintext,  
    input [3:0] key,  
    output reg [3:0] ciphertext  
);  
    // Substitution box (S-Box)  
    reg [3:0] sbox [0:15];  
    initial begin  
        sbox[0] = 4'hE; sbox[1] = 4'h3; sbox[2] = 4'hB; sbox[3] = 4'h7;  
        sbox[4] = 4'h9; sbox[5] = 4'h2; sbox[6] = 4'hD; sbox[7] = 4'h5;  
        sbox[8] = 4'hA; sbox[9] = 4'hC; sbox[10] = 4'h1; sbox[11] = 4'hF;  
        sbox[12] = 4'h0; sbox[13] = 4'h6; sbox[14] = 4'h8; sbox[15] = 4'h4;  
    end  

    // Encryption process  
    always @(posedge clk) begin  
        // Substitution  
        ciphertext <= sbox[plaintext ^ key];  
    end  
endmodule