module rnn_cell (
    input clk,
    input rst,
    input [3:0] x,        // 4-bit input
    input [3:0] prev_state, // 4-bit previous state
    output reg [3:0] next_state // 4-bit next state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        next_state <= 4'b0000; // Reset state
    end else begin
        next_state <= x ^ prev_state; // Compute next state
    end
end

endmodule