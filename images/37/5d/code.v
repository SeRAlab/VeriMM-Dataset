module chacha20_simple (
    input [255:0] key,
    input [63:0] nonce,
    output reg [31:0] output_value
);
    always @(key, nonce) begin
        // Simple operation: add upper 32 bits of key with nonce and rotate
        output_value = (key[255:224] + nonce[63:32]) ^ (key[255:224] << 8 | key[255:224] >> 24);
    end
endmodule