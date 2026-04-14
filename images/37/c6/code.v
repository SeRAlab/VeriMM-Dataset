module rnn_cell (
    input clk,
    input rst,
    input [7:0] x,       // input vector
    input [7:0] h_prev,  // previous hidden state
    output reg [7:0] h_out // new hidden state
);

// Parameters for weights (for simplicity, they are hardcoded)
parameter [7:0] W_x = 8'd2; // weight for input
parameter [7:0] W_h = 8'd3; // weight for hidden state

always @(posedge clk or posedge rst) begin
    if (rst) begin
        h_out <= 8'd0; // reset hidden state
    end else begin
        h_out <= (W_x * x + W_h * h_prev) >> 1; // simple update rule
    end
end
endmodule