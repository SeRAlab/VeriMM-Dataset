module gradient_descent_optimizer (
    input clk,
    input reset,
    input [15:0] error_signal, // Error signal input
    input [15:0] learning_rate, // Learning rate input
    output reg [15:0] weight // Weight output
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            weight <= 16'b0; // Initialize weight to 0
        end else begin
            weight <= weight - (learning_rate * error_signal >> 8); // Update weight
        end
    end
    
endmodule