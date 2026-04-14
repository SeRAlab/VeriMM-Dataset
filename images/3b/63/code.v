module des_single_round (
    input [63:0] data_in,
    input [63:0] key,
    output reg [63:0] data_out
);
    // Initial permutation (simplified)
    wire [63:0] permuted_data;
    assign permuted_data = {data_in[63:56], data_in[55:48], data_in[47:40], data_in[39:32],
                            data_in[31:24], data_in[23:16], data_in[15:8], data_in[7:0]};

    // Key mixing (simplified)
    wire [63:0] mixed_data;
    assign mixed_data = permuted_data ^ key;

    // Substitution (using a simplified S-box)
    wire [31:0] substituted_data;
    assign substituted_data = {
        mixed_data[31:24] ^ 8'h5A,
        mixed_data[23:16] ^ 8'h6B,
        mixed_data[15:8] ^ 8'h7C,
        mixed_data[7:0] ^ 8'h8D
    };

    // Final permutation (simplified)
    always @(*) begin
        data_out = {substituted_data[31:28], substituted_data[27:24], substituted_data[23:20],
                    substituted_data[19:16], substituted_data[15:12], substituted_data[11:8],
                    substituted_data[7:4], substituted_data[3:0]};
    end
endmodule