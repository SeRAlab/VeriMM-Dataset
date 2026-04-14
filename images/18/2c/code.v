module AES_AddRoundKey (
    input [127:0] plaintext,
    input [127:0] key,
    output reg [127:0] ciphertext
);

always @(*) begin
    ciphertext = plaintext ^ key;
end

endmodule