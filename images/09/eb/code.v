module simplified_DES (
    input [63:0] plaintext,
    input [55:0] key,
    output reg [63:0] ciphertext,
    input clk,
    input rst
);
    reg [63:0] permuted_input;
    reg [31:0] left_half;
    reg [31:0] right_half;
    reg [32:0] expanded_right;
    reg [55:0] subkey;
    reg [31:0] f_output;

    // Initial permutation (for demonstration)
    function [63:0] initial_permutation;
        input [63:0] data;
        // Define the permutation (example)
        // Just a simple reverse for demonstration
        initial_permutation = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7],
                               data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15],
                               data[16], data[17], data[18], data[19], data[20], data[21], data[22], data[23],
                               data[24], data[25], data[26], data[27], data[28], data[29], data[30], data[31],
                               data[32], data[33], data[34], data[35], data[36], data[37], data[38], data[39],
                               data[40], data[41], data[42], data[43], data[44], data[45], data[46], data[47],
                               data[48], data[49], data[50], data[51], data[52], data[53], data[54], data[55],
                               data[56], data[57], data[58], data[59], data[60], data[61], data[62], data[63]};
    endfunction

    // Example key schedule (for demonstration)
    function [55:0] key_schedule;
        input [55:0] k;
        // Just a simple rotation for demonstration
        key_schedule = {k[54:0], k[55]}; // Rotate left
    endfunction

    // Example Feistel function (for demonstration)
    function [31:0] feistel_function;
        input [31:0] r;
        input [55:0] k;
        // Just a simple XOR for demonstration
        feistel_function = r ^ k[31:0]; // XOR with the first 32 bits of the key
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 64'b0;
        end else begin
            permuted_input <= initial_permutation(plaintext);
            left_half <= permuted_input[63:32];
            right_half <= permuted_input[31:0];
            subkey <= key_schedule(key);
            f_output <= feistel_function(right_half, subkey);
            ciphertext <= {right_half, left_half ^ f_output}; // Swap and encrypt
        end
    end
endmodule