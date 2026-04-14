module rnn_cell (
    input [2:0] x,          // Input vector
    input clk,              // Clock signal
    input rst,              // Reset signal
    output reg [2:0] h      // Output vector (hidden state)
);
    reg [2:0] h_prev;       // Previous hidden state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 3'b000;     // Reset output to zero
            h_prev <= 3'b000; // Reset previous state to zero
        end else begin
            // Simple RNN update: h = tanh(W * h_prev + x)
            h <= (h_prev + x) > 3'b000 ? 3'b111 : 3'b000; // Example activation
            h_prev <= h;      // Update previous state
        end
    end
endmodule