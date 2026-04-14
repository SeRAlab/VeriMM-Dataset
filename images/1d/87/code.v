module rnn_cell (
    input [3:0] input_vector,
    input [3:0] hidden_state,
    output reg [3:0] new_hidden_state
);
    
    // Hardcoded weights and bias for the demonstration
    reg [3:0] W_hh = 4'b0101; // weight for hidden state
    reg [3:0] W_xh = 4'b0011; // weight for input
    reg [3:0] b = 4'b0001;     // bias

    always @(*) begin
        // Calculate new hidden state using a simple weighted sum
        new_hidden_state = W_hh & hidden_state + W_xh & input_vector + b;
        // Apply a simple activation function (tanh approximation)
        if (new_hidden_state > 4'b0111) 
            new_hidden_state = 4'b0111; // max value
        else if (new_hidden_state < 4'b1000) 
            new_hidden_state = 4'b1000; // min value
    end
endmodule