module rnn_cell (
    input clk,
    input [7:0] input_data,
    input [7:0] prev_hidden_state,
    output reg [7:0] new_hidden_state
);
    // Define weights and bias (for simplicity, we'll use small constant values)
    parameter [7:0] W = 8'd1; // Weight for input
    parameter [7:0] U = 8'd1; // Weight for previous hidden state
    parameter [7:0] b = 8'd0;  // Bias
    
    always @(posedge clk) begin
        // Update hidden state using a simple activation function (for example, a linear approximation of tanh)
        new_hidden_state <= (W * input_data + U * prev_hidden_state + b);
    end
endmodule