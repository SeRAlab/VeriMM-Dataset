module des_one_round (
    input wire [63:0] data_in,
    input wire [55:0] key,
    output wire [63:0] data_out
);
    wire [31:0] left, right, expanded_right, xor_result, subkey;
    wire [31:0] sbox_output, permuted_output;

    assign left = data_in[63:32];
    assign right = data_in[31:0];

    // Expand and permute the right half
    // For simplicity, we are using a simple expansion
    assign expanded_right = {right[31:24], right[31:24], right[23:16], right[23:16], right[15:8], right[15:8], right[7:0], right[7:0]};

    // XOR with the key (for demonstration, we're using the first 32 bits of the key)
    assign xor_result = expanded_right ^ {key[55:40], key[55:40], key[39:24], key[39:24], key[23:8], key[23:8], key[7:0], key[7:0]};
    
    // Simple S-box substitution (example with two S-boxes)
    assign sbox_output = xor_result[31:24] ^ xor_result[23:16]; // Simplified S-box mapping

    // Permutation of S-box output (for demonstration, a simple pass-through)
    assign permuted_output = sbox_output;

    // Combine left and new right
    assign data_out = {right, left ^ permuted_output};
endmodule