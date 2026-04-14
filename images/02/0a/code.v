module md5_hash (
    input clk,
    input reset,
    input [127:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 128'h0;
            hash_out <= 128'h0;
        end else begin
            // Simple mixing function for MD5-like hashing
            state <= state + data_in; // Simple addition for demonstration
            hash_out <= {state[63:0], state[127:64]} ^ (state << 7) ^ (state >> 3);
        end
    end
endmodule