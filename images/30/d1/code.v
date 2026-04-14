module rnn_cell (
    input wire clk,
    input wire reset,
    input wire [3:0] input_vector,
    input wire [3:0] hidden_state,
    output reg [3:0] output_vector,
    output reg [3:0] new_hidden_state
);
    // Hardcoded weights for input and hidden state
    reg [3:0] W_input [0:3]; // Weights for input
    reg [3:0] W_hidden [0:3]; // Weights for hidden state

    initial begin
        W_input[0] = 4'b0001; W_input[1] = 4'b0010; W_input[2] = 4'b0100; W_input[3] = 4'b1000; // Example weights
        W_hidden[0] = 4'b0001; W_hidden[1] = 4'b0010; W_hidden[2] = 4'b0100; W_hidden[3] = 4'b1000; // Example weights
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_hidden_state <= 4'b0000;
            output_vector <= 4'b0000;
        end else begin
            new_hidden_state <= (W_input[0] & input_vector[0]) + 
                                (W_input[1] & input_vector[1]) + 
                                (W_input[2] & input_vector[2]) + 
                                (W_input[3] & input_vector[3]) + 
                                (W_hidden[0] & hidden_state[0]) + 
                                (W_hidden[1] & hidden_state[1]) + 
                                (W_hidden[2] & hidden_state[2]) + 
                                (W_hidden[3] & hidden_state[3]);
            output_vector <= new_hidden_state;
        end
    end
endmodule