module des_encrypt (
    input [7:0] plaintext,
    input [7:0] key,
    input clk,
    output reg [7:0] ciphertext
);

    reg [7:0] rotated_key;

    always @(posedge clk) begin
        // Rotate key left by 1
        rotated_key <= {key[6:0], key[7]};
        // Encrypt by XORing plaintext with rotated key
        ciphertext <= plaintext ^ rotated_key;
    end
endmodule