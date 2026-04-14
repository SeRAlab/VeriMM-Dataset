module RSA_Encrypt (
    input [15:0] plaintext,
    input [15:0] public_key,
    output [15:0] ciphertext
);
    // Fixed modulus (n)
    parameter n = 65537;

    // Calculate ciphertext as plaintext^public_key mod n
    wire [31:0] temp_ciphertext;

    assign temp_ciphertext = plaintext ** public_key;
    assign ciphertext = temp_ciphertext % n;

endmodule