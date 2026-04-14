module rsa_encrypt (
    input [4:0] plaintext,
    output reg [4:0] ciphertext
);
    
    parameter e = 3;
    parameter n = 31;

    always @(*) begin
        ciphertext = (plaintext ** e) % n;
    end
endmodule