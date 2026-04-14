module rnn_cell #(parameter INPUT_SIZE = 5, parameter HIDDEN_SIZE = 5) (
    input clk,
    input reset,
    input [INPUT_SIZE-1:0] x,          // Input vector
    input [HIDDEN_SIZE-1:0] h_prev,     // Previous hidden state
    output reg [HIDDEN_SIZE-1:0] h_new, // New hidden state
    output reg [HIDDEN_SIZE-1:0] y       // Output vector
);
    // Weights for simplicity (in a real RNN, these would be learned parameters)
    reg [HIDDEN_SIZE-1:0] Wxh [0:INPUT_SIZE-1];    // Weights from input to hidden
    reg [HIDDEN_SIZE-1:0] Whh [0:HIDDEN_SIZE-1];    // Weights from hidden to hidden
    integer i, j;

    initial begin
        // Initialize weights
        Wxh[0] = 5'b00001; Wxh[1] = 5'b00010; Wxh[2] = 5'b00011; Wxh[3] = 5'b00100; Wxh[4] = 5'b00101;
        Whh[0] = 5'b00001; Whh[1] = 5'b00010; Whh[2] = 5'b00011; Whh[3] = 5'b00100; Whh[4] = 5'b00101;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_new <= 0;
            y <= 0;
        end else begin
            // Simple RNN update
            h_new = 0;
            for (i = 0; i < INPUT_SIZE; i = i + 1) begin
                h_new = h_new + (Wxh[i] * x[i]);
            end
            for (j = 0; j < HIDDEN_SIZE; j = j + 1) begin
                h_new = h_new + (Whh[j] * h_prev[j]);
            end
            y = h_new; // Output is equal to the new hidden state for simplicity
        end
    end
endmodule