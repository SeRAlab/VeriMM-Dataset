module des_round (
    input wire [63:0] data_in,
    input wire [55:0] key,
    output reg [63:0] data_out
);
    // Simple permutation for initial permutation (IP)
    reg [63:0] ip;
    always @(*) begin
        ip = {data_in[63:56], data_in[47:40], data_in[31:24], data_in[15:8],
              data_in[55:48], data_in[39:32], data_in[23:16], data_in[7:0]};
    end

    // S-Box substitution (simplified)
    reg [63:0] sbox_out;
    always @(*) begin
        sbox_out[63:56] = ip[63:56] ^ key[55:48];
        sbox_out[55:48] = ip[55:48] ^ key[47:40];
        sbox_out[47:40] = ip[47:40] ^ key[39:32];
        sbox_out[39:32] = ip[39:32] ^ key[31:24];
        sbox_out[31:24] = ip[31:24] ^ key[23:16];
        sbox_out[23:16] = ip[23:16] ^ key[15:8];
        sbox_out[15:8] = ip[15:8] ^ key[7:0];
        sbox_out[7:0] = ip[7:0] ^ key[55:48];
    end

    // Outputting the final result after the round
    always @(*) begin
        data_out = sbox_out;
    end
endmodule