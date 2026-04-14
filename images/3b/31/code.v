module rnn_cell (
    input clk,
    input [3:0] input_data,
    input [3:0] hidden_state,
    output reg [3:0] new_hidden_state
);
    // Fixed weights for simplicity (W and U)
    parameter [3:0] W = 4'b1010; // Example weight matrix W
    parameter [3:0] U = 4'b0101; // Example weight matrix U
    
    always @(posedge clk) begin
        // Calculate the new hidden state
        new_hidden_state <= (W * input_data + U * hidden_state) >> 1; // Simple operation to emulate tanh
    end
endmodule