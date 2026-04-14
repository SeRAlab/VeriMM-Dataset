module md5_hash (
    input clk,
    input reset,
    input [63:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] temp_hash;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash_out <= 128'h0;
            temp_hash <= 128'h0;
        end else begin
            // Simple hashing operation for illustration
            temp_hash <= (temp_hash << 7) + data_in;
            hash_out <= temp_hash ^ (temp_hash >> 3);
        end
    end
endmodule