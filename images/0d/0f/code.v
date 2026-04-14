module md5_hash(
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] hash_out
);

    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 4'b0000;
            hash_out <= 4'b0000;
        end else begin
            state <= (state ^ data_in) << 1; // XOR and rotate left
            hash_out <= state;
        end
    end
endmodule