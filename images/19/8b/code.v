module rsa_encryption(  
    input [4:0] plaintext,  
    input [4:0] key,  
    output [4:0] ciphertext  
);  
    assign ciphertext = plaintext ^ key;  
endmodule