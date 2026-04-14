module md5_hash (
    input wire clk,
    input wire reset,
    input wire [63:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 128'h0;
            hash_out <= 128'h0;
        end else begin
            // Simple transformation for demonstration
            state[63:0] <= state[63:0] + data_in;
            state[127:64] <= state[127:64] ^ data_in;
            hash_out <= state; // Output the current state as the hash
        end
    end
endmodule