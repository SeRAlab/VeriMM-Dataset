module md5_hash (
    input [3:0] data_in,
    input clk,
    output reg [3:0] hash_out
);
    always @(posedge clk) begin
        // Simple hash function: rotate left and XOR with a constant
        hash_out <= {data_in[2:0], data_in[3]} ^ 4'b1010; // Rotate left and XOR with 10
    end
endmodule