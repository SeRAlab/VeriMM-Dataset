module rsa_encrypt(input [9:0] plaintext, input [7:0] key, output [9:0] ciphertext);  
    assign ciphertext = plaintext * key % 1024;  
endmodule