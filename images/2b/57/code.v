module rnn_cell (
    input [15:0] x,       // Input vector of size 4 (4 bits each)
    input [15:0] h_prev,  // Previous hidden state of size 4 (4 bits each)
    output reg [15:0] h_out // Output hidden state of size 4
);
    // Fixed weights for the example
    reg [15:0] w_x = 16'h0002; // Weight for input
    reg [15:0] w_h = 16'h0003; // Weight for hidden state

    always @(x or h_prev) begin
        // Simple RNN update rule: h_out = w_x * x + w_h * h_prev
        h_out = (w_x * x) + (w_h * h_prev);
    end
endmodule