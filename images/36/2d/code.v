module md5_hash (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] hash_out
);
    reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
            hash_out <= 4'b0000;
        end else begin
            state <= state ^ data_in; // XOR the current state with the input data
            hash_out <= state; // Update the output with the current state
        end
    end
endmodule