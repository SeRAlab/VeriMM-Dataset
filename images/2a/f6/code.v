module rsa_encryption(  
    input [15:0] plaintext,  
    input [15:0] public_key,  
    output reg [15:0] ciphertext  
);  
    parameter e = 16'h0003; // Public exponent  
    parameter n = 16'h10001; // Modulo (65537)  

    always @(*) begin  
        ciphertext = (plaintext ** e) % n;  
    end  
endmodule