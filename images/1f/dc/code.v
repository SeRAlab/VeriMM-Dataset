module neural_network (
    input [1:0] x,          // 2-bit input
    output reg y           // 1-bit output
);
    // Predefined weights and biases
    parameter W1_1 = 4'd1, W1_2 = 4'd2; // weights from input to hidden layer
    parameter B1 = 4'd1;                // bias for hidden layer
    parameter W2_1 = 4'd1, W2_2 = 4'd1; // weights from hidden to output layer
    parameter B2 = 4'd0;                // bias for output layer

    // Hidden layer signals
    wire [3:0] hidden1, hidden2;
    wire [3:0] activation_hidden1, activation_hidden2;
    
    // Calculate hidden layer outputs with sigmoid activation
    assign hidden1 = W1_1 * x[0] + W1_2 * x[1] + B1;
    assign hidden2 = W1_1 * x[1] + W1_2 * x[0] + B1; 
    
    // Sigmoid activation function approximation
    assign activation_hidden1 = (hidden1 > 4'd2) ? 4'd1 : 4'd0; // thresholding for sigmoid
    assign activation_hidden2 = (hidden2 > 4'd2) ? 4'd1 : 4'd0; // thresholding for sigmoid

    // Output layer calculation
    wire [3:0] output_sum;
    assign output_sum = W2_1 * activation_hidden1 + W2_2 * activation_hidden2 + B2;

    // Linear output (for simplicity, thresholding to get 1-bit output)
    always @(*) begin
        y = (output_sum > 4'd1) ? 1'b1 : 1'b0;
    end
endmodule