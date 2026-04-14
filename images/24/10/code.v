module rnn_cell (
    input [3:0] x,      // Input vector
    input [3:0] h_in,   // Previous hidden state
    output reg [3:0] h_out // New hidden state
);
    always @(x or h_in) begin
        // Simple update rule for the hidden state
        h_out = (x + h_in) % 16; // Keeping the output within 4 bits
    end
endmodule