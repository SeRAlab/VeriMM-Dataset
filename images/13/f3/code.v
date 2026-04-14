module rnn_cell (
    input [7:0] x,          // Input to the RNN cell
    input [7:0] h_prev,     // Previous hidden state
    output reg [7:0] h      // New hidden state
);
    // Parameters for weights and bias (fixed values for simplicity)
    parameter [7:0] Wxh = 8'd2; // Weight for input
    parameter [7:0] Whh = 8'd3; // Weight for hidden state
    parameter [7:0] b = 8'd1;    // Bias

    always @(*) begin
        // Compute new hidden state
        h = (Wxh * x + Whh * h_prev + b) >>> 1; // Using bit-shift as a simple way to approximate tanh
    end
endmodule