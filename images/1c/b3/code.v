module rsa_encrypt (
    input [3:0] plaintext,
    output [3:0] ciphertext
);
    wire [7:0] temp;

    assign temp = plaintext ** 3; // plaintext raised to the power of e
    assign ciphertext = temp % 13; // take modulo n

endmodule