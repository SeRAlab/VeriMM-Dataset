module rnn_cell(
    input [3:0] x,        // Input vector
    input [3:0] h_prev,   // Previous hidden state
    output reg [3:0] h_new // New hidden state
);

    // Parameters for weights (for simplicity, using small fixed values)
    localparam Wxh = 2;  // Weight for input to hidden
    localparam Whh = 1;  // Weight for hidden to hidden

    always @(*) begin
        // Simple RNN operation: h_new = tanh(Wxh * x + Whh * h_prev)
        // Here we use a simple linear combination and saturation instead of tanh
        h_new = (Wxh * x + Whh * h_prev > 15) ? 4'b1111 : (Wxh * x + Whh * h_prev);
    end
endmodule