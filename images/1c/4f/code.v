module simple_des(  
    input [63:0] plaintext,  
    input [63:0] key,  
    output reg [63:0] ciphertext  
);  

    // Simplified S-box (for demonstration purposes)  
    reg [5:0] sbox[0:3][0:15];  
    initial begin  
        // Fill S-box with arbitrary values for testing  
        sbox[0][0] = 6'd12; sbox[0][1] = 6'd5; sbox[0][2] = 6'd3; sbox[0][3] = 6'd10;  
        sbox[0][4] = 6'd9; sbox[0][5] = 6'd0; sbox[0][6] = 6'd7; sbox[0][7] = 6'd15;  
        sbox[0][8] = 6'd14; sbox[0][9] = 6'd1; sbox[0][10] = 6'd8; sbox[0][11] = 6'd4;  
        sbox[0][12] = 6'd11; sbox[0][13] = 6'd6; sbox[0][14] = 6'd13; sbox[0][15] = 6'd2;  
        // Additional S-boxes can be initialized here...  
    end  

    always @(plaintext or key) begin  
        // A simple DES-like transformation  
        ciphertext = plaintext ^ key;  // XOR with key for demonstration  
        // Apply a simplified S-box transformation on the first 6 bits  
        ciphertext[5:0] = sbox[0][ciphertext[5:0]];  
    end  
endmodule