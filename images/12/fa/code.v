module backpropagation (
    input wire [15:0] weights,      // Current weights (16 bits)
    input wire [15:0] learning_rate, // Learning rate (16 bits)
    input wire [15:0] error_signal,  // Error signal (16 bits)
    output reg [15:0] updated_weights // Updated weights (16 bits)
);
    always @(*) begin
        updated_weights = weights - (learning_rate * error_signal);
    end
endmodule