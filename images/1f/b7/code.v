module rsa_encrypt (
    input [3:0] plaintext,
    input [3:0] key,
    output reg [3:0] ciphertext
);
    always @(*) begin
        ciphertext = (plaintext ** key) % 16;
    end
endmodule