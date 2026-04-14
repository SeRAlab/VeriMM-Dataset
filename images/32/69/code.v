module RSA_Encryption(  
    input [9:0] plaintext,  
    input [9:0] exponent,  
    input [9:0] modulus,  
    output reg [9:0] ciphertext  
);  
    always @(*) begin  
        if (modulus == 0) begin  
            ciphertext = 0;  
        end else begin  
            ciphertext = (plaintext ** exponent) % modulus;  
        end  
    end  
endmodule