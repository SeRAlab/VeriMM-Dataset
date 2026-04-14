module aes_encryption (  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext  
);  
    // Simple example of a single round AES encryption.  
    // Note: Actual AES involves complex operations like S-box, MixColumns, etc.  
    always @(*) begin  
        // Dummy transformation for demonstration purposes  
        ciphertext = plaintext ^ key; // Simple XOR for one round  
    end  
endmodule