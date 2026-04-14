module rsa_encryption (  
    input [3:0] plaintext,  
    input [3:0] public_key,  
    output reg [3:0] ciphertext  
);  
    always @(*) begin  
        ciphertext = (plaintext ^ public_key) % 16;  
    end  
endmodule