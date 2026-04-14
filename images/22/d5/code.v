module simple_des (
    input clk,
    input rst,
    input [63:0] data_in,
    input [55:0] key,
    output reg [63:0] data_out
);

    // Simple round function implementation
    wire [47:0] expanded_data;
    wire [31:0] substituted_data;
    wire [63:0] permuted_data;

    // Dummy implementation of expansion, substitution, and permutation
    assign expanded_data = {data_in[31:0], data_in[63:32]}; // Example expansion
    assign substituted_data = expanded_data[31:0]; // Dummy substitution
    assign permuted_data = {substituted_data, substituted_data}; // Dummy permutation

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 64'b0;
        end else begin
            data_out <= permuted_data; // Output after one round
        end
    end
endmodule