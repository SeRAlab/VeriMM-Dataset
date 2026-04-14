module rnn_inference(
    input clk,
    input reset,
    input [4:0] input_vector,
    input [2:0] hidden_state,
    output reg [2:0] output_vector
);
    // Simple weight for RNN
    reg [2:0] weights = 3'b101; // Example weights

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_vector <= 3'b000;
        end else begin
            // Simple activation function: XOR input and weighted hidden state
            output_vector <= (input_vector[0] ^ hidden_state[0]) * weights[0] ^
                             (input_vector[1] ^ hidden_state[1]) * weights[1] ^
                             (input_vector[2] ^ hidden_state[2]) * weights[2];
        end
    end
endmodule