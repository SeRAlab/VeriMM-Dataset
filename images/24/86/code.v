module md5_hash(
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [31:0] hash_out
);

    parameter constant_value = 32'hA5A5A5A5; // Predefined constant for hashing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 32'b0; // Reset output to 0
        end else begin
            hash_out <= data_in ^ constant_value; // Simple XOR operation for hashing
        end
    end

endmodule