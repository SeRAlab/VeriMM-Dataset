module rnn_cell (
    input clk,
    input reset,
    input [7:0] x,        // Input vector
    input [7:0] h_prev,   // Previous hidden state
    output reg [7:0] h_new // New hidden state
);
    // Simple weight and bias for demonstration (fixed values)
    parameter W_x = 8'd2;  // Weight for input
    parameter W_h = 8'd3;  // Weight for hidden state
    parameter bias = 8'd1;  // Bias term
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_new <= 8'd0;  // Reset hidden state
        end else begin
            // Compute new hidden state with a simple activation (tanh is not implemented, just a linear example)
            h_new <= (W_x * x + W_h * h_prev + bias) >> 1; // Simple linear combination for demonstration
        end
    end
endmodule