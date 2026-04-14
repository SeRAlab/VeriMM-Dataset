module simplified_DES(
    input wire clk,
    input wire rst,
    input wire [63:0] data_in,
    input wire [63:0] key,
    output reg [63:0] data_out
);
    reg [31:0] L, R, L_temp, R_temp;
    reg [63:0] key_schedule [1:0]; // Just 2 keys for 2 rounds

    // Initial key schedule
    always @(*) begin
        key_schedule[0] = key; // Round 0 key
        key_schedule[1] = {key[63:32] ^ 32'hFFFFFFFF, key[31:0]}; // Round 1 key (example transformation)
    end

    // Simple Feistel function
    function [31:0] F;
        input [31:0] R;
        input [63:0] key;
        begin
            F = R ^ key[31:0]; // Simple XOR with key
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 64'h0;
        end else begin
            // Split data into two halves
            L <= data_in[63:32];
            R <= data_in[31:0];

            // Round 1
            L_temp = L;
            R_temp = R ^ F(R, key_schedule[0]);
            L <= R_temp;
            R <= L_temp;

            // Round 2
            L_temp = L;
            R_temp = R ^ F(R, key_schedule[1]);
            data_out <= {R_temp, L_temp}; // Combine the halves for output
        end
    end
endmodule