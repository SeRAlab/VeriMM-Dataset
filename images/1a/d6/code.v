module rsa_encrypt (  
    input [15:0] plaintext,  
    input [15:0] e,  
    input [31:0] n,  
    output reg [31:0] ciphertext  
);  
    always @(*) begin  
        ciphertext = (plaintext ** e) % n;  
    end  
endmodule