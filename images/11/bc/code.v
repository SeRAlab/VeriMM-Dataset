module aes_key_expansion(
    input wire [255:0] key,
    output wire [127:0] round_key
);
    assign round_key = key[127:0]; // Simplified: just output the first 128 bits
endmodule