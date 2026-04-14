module backpropagation (
    input [7:0] input_data,      // 8-bit input data
    input [7:0] weights,          // 8-bit weights
    input [7:0] expected_output,  // 8-bit expected output
    input [7:0] learning_rate,    // 8-bit learning rate
    output reg [7:0] updated_weights // 8-bit updated weights
);
    reg [7:0] error;
    reg [7:0] adjustment;

    always @(*) begin
        // Calculate error
        error = expected_output - (input_data * weights);
        
        // Calculate adjustment
        adjustment = (error * learning_rate) >> 4; // Scale the adjustment
        
        // Update weights
        updated_weights = weights + adjustment;
    end
endmodule