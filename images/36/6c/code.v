module rsa_encryption (
    input [15:0] plaintext,
    input [15:0] public_key,
    output reg [15:0] ciphertext
);
    parameter n = 16'hB5A3; // Example modulus

    always @(*) begin
        ciphertext = (plaintext ** public_key) % n;
    end
endmodule