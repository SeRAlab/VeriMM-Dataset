module simplified_DES (
    input wire [63:0] plaintext,
    input wire [63:0] key,
    input wire clk,
    input wire rst,
    output reg [63:0] ciphertext
);
    // Internal wires and registers
    reg [63:0] permuted_input;
    reg [63:0] round_key;
    reg [63:0] temp_output;

    // Initial permutation (simplified)
    function [63:0] initial_permutation;
        input [63:0] data;
        begin
            initial_permutation = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7],
                                   data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15],
                                   data[16], data[17], data[18], data[19], data[20], data[21], data[22], data[23],
                                   data[24], data[25], data[26], data[27], data[28], data[29], data[30], data[31],
                                   data[32], data[33], data[34], data[35], data[36], data[37], data[38], data[39],
                                   data[40], data[41], data[42], data[43], data[44], data[45], data[46], data[47],
                                   data[48], data[49], data[50], data[51], data[52], data[53], data[54], data[55],
                                   data[56], data[57], data[58], data[59], data[60], data[61], data[62], data[63]};
        end
    endfunction

    // Simplified f function
    function [63:0] f_function;
        input [63:0] data;
        input [63:0] key;
        begin
            f_function = data ^ key; // Simple XOR for demonstration
        end
    endfunction

    // Key schedule (for demo, using the initial key)
    always @(*) begin
        round_key = key;
    end

    // Sequential processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 64'b0;
        end else begin
            permuted_input <= initial_permutation(plaintext);
            temp_output <= f_function(permuted_input, round_key);
            ciphertext <= temp_output; // Simplified for demonstration (1 round)
        end
    end
endmodule