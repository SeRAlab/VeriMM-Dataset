module des_encryption (
    input [63:0] plaintext,
    input [63:0] key,
    output reg [63:0] ciphertext
);
    // Initial Permutation (example)
    reg [63:0] initial_permuted;
    reg [31:0] left, right;
    reg [31:0] round_key;

    // Simple round function
    function [31:0] round_function;
        input [31:0] half_block;
        input [31:0] round_key;
        begin
            round_function = half_block ^ round_key; // Simple XOR for round function
        end
    endfunction

    always @(plaintext or key) begin
        // Initial permutation (for example)
        initial_permuted = {plaintext[63:32], plaintext[31:0]};
        left = initial_permuted[63:32];
        right = initial_permuted[31:0];
        round_key = key[63:32]; // Simplifying to use only part of the key

        // Single round of Feistel function
        right = right ^ round_function(left, round_key);
        left = left ^ round_function(right, round_key);

        // Final permutation (for example, just concatenating for simplicity)
        ciphertext = {right, left}; // Final output
    end
endmodule