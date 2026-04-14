module rsa_encrypt (
    input [9:0] plaintext,
    input [9:0] exponent,
    output reg [9:0] ciphertext
);
    always @(*) begin
        ciphertext = (plaintext ^ exponent) % 1024;
    end
endmodule