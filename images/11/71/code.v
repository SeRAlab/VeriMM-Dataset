module rnn_cell (
    input [3:0] x,          // Input vector
    input [3:0] h_prev,     // Previous hidden state
    output reg [3:0] h_out  // Updated hidden state
);
    
    // Sigmoid approximation
    function [3:0] sigmoid;
        input [3:0] in;
        begin
            // Simple sigmoid approximation
            sigmoid = in / (in + 4'b0001);
        end
    endfunction

    always @(x, h_prev) begin
        // Update hidden state using simple RNN formula: h = sigmoid(W*x + U*h_prev)
        // Here, we simplify and use a fixed weight of 1 for both x and h_prev
        h_out = sigmoid(x + h_prev);
    end
endmodule