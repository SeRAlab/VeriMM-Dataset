module gradient_descent(
    input [1:0] weight_1,
    input [1:0] weight_2,
    input [1:0] input_1,
    input [1:0] input_2,
    input [1:0] target_output,
    input [1:0] learning_rate,
    output reg [1:0] updated_weight_1,
    output reg [1:0] updated_weight_2
);
    
    wire [3:0] prediction;
    wire [3:0] error;
    wire [3:0] gradient_1;
    wire [3:0] gradient_2;
    
    assign prediction = (weight_1 * input_1) + (weight_2 * input_2);
    assign error = target_output - prediction;
    
    assign gradient_1 = (error * input_1) >> 1; // Scale down for 2-bit output
    assign gradient_2 = (error * input_2) >> 1; // Scale down for 2-bit output
    
    always @(*) begin
        updated_weight_1 = weight_1 + (gradient_1 * learning_rate);
        updated_weight_2 = weight_2 + (gradient_2 * learning_rate);
    end
endmodule