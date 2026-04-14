module aes_round (
    input [127:0] plaintext,
    input [127:0] key,
    output reg [127:0] ciphertext
);
    
    // SubBytes, ShiftRows, MixColumns, and AddRoundKey functions
    // These functions need to be implemented as per AES specification
    
    // Sample implementation (the actual implementation would be more complex)
    always @(*) begin
        // Just a placeholder implementation
        ciphertext = plaintext ^ key; // This is not AES, just for example
    end
endmodule