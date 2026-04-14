module aes_round(
    input wire [127:0] plaintext,
    input wire [127:0] key,
    output reg [127:0] ciphertext
);
    always @(*) begin
        ciphertext = plaintext ^ key; // AddRoundKey operation
    end
endmodule