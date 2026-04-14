module rnn_cell (
    input wire [7:0] x,          // Current input
    input wire [7:0] h_prev,     // Previous hidden state
    output reg [7:0] h_out       // New hidden state
);
    // Define weights (fixed for simplicity)
    parameter [7:0] W_hh = 8'd2; // Weight for h_prev
    parameter [7:0] W_xh = 8'd3;  // Weight for x
    
    always @(*) begin
        // Calculate the new hidden state
        // Note: This is a simplified version without actual tanh for clarity
        h_out = (W_hh * h_prev + W_xh * x) >> 1; // Simple linear approximation
    end
endmodule