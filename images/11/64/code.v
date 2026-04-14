module aes_round(  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext  
);  
    // S-box (For simplicity, a small part of the S-box is used here)  
    reg [7:0] sbox [0:255];  
    initial begin  
        // Initialize S-box with some values  
        sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77;  
        // More S-box values need to be filled in here...  
        sbox[8'hff] = 8'h00; // Example for the last value  
    end  

    integer i;  
    always @(*) begin  
        // Substitution layer  
        for (i = 0; i < 16; i = i + 1) begin  
            ciphertext[i*8 +: 8] = sbox[plaintext[i*8 +: 8]];  
        end  
        // P-layer (simple permutation)  
        ciphertext = {ciphertext[0], ciphertext[4], ciphertext[8], ciphertext[12],  
                      ciphertext[1], ciphertext[5], ciphertext[9], ciphertext[13],  
                      ciphertext[2], ciphertext[6], ciphertext[10], ciphertext[14],  
                      ciphertext[3], ciphertext[7], ciphertext[11], ciphertext[15]};  
    end  
endmodule