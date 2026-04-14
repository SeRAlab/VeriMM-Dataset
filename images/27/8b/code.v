module aes_add_round_key (
    input wire [127:0] plaintext,
    input wire [127:0] round_key,
    output reg [127:0] ciphertext
);
    always @(*) begin
        ciphertext = plaintext ^ round_key; // XOR operation
    end
endmodule