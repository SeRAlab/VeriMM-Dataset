module rsa_encrypt(  
    input [9:0] plaintext,  
    input [9:0] e,  
    output [9:0] ciphertext  
);  
    assign ciphertext = (plaintext ** e) % 1024;  
endmodule