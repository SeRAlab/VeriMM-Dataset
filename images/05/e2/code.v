module rsa_encrypt (
    input [7:0] plaintext,
    input [7:0] n,
    input [7:0] e,
    output [7:0] ciphertext
);
    wire [15:0] temp;

    assign temp = plaintext ** e; // Exponentiation operation
    assign ciphertext = temp % n; // Modulo operation

endmodule