module rnn_cell (
    input clk,
    input [3:0] x,           // Input vector
    input [3:0] h_prev,      // Previous hidden state
    output reg [3:0] h_new   // New hidden state
);

    wire [7:0] h_temp;       // Intermediate computation
    
    // Simple RNN update: h_new = sigmoid(w*x + u*h_prev)
    // For simplicity, we assume weights w and u are fixed
    assign h_temp = (2 * x) + (2 * h_prev); // weights are considered as 2 for simplicity

    // Simple sigmoid function approximation
    always @(posedge clk) begin
        if (h_temp > 8'hFF) 
            h_new <= 4'b1111; // saturate to max if overflow
        else if (h_temp > 8'h7F)
            h_new <= 4'b0111; // sigmoid approximation
        else if (h_temp > 8'h3F)
            h_new <= 4'b0011; // sigmoid approximation
        else
            h_new <= 4'b0000; // sigmoid approximation
    end
endmodule