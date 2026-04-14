module rnn_cell (
    input clk,
    input reset,
    input [3:0] x,         // 4-bit input
    input [3:0] h_prev,    // 4-bit previous hidden state
    output reg [3:0] h_out, // 4-bit output hidden state
    output reg [3:0] y      // 4-bit output
);

    // Simple weight coefficients for the RNN
    // Assume weights for input and hidden state are fixed
    reg [3:0] w_ih = 4'b0011; // Weights for input (example: 3)
    reg [3:0] w_hh = 4'b0101; // Weights for hidden (example: 5)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_out <= 4'b0000;
            y <= 4'b0000;
        end else begin
            // Calculate new hidden state
            h_out <= (x & w_ih) + (h_prev & w_hh);
            // Apply ReLU activation function
            if (h_out < 4'b0000) 
                h_out <= 4'b0000;
            // Output is the new hidden state (or can be any function of it)
            y <= h_out;
        end
    end
endmodule