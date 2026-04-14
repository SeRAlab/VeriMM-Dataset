module logistic_regression(  
    input [3:0] feature1,  
    input [3:0] feature2,  
    input [3:0] feature3,  
    output reg predicted_class  
);  
    // Fixed weights (4-bit unsigned integers)  
    parameter [3:0] weight1 = 4'b0110; // weight for feature1  
    parameter [3:0] weight2 = 4'b0101; // weight for feature2  
    parameter [3:0] weight3 = 4'b0011; // weight for feature3  
    wire [7:0] weighted_sum;  
    wire [15:0] sigmoid_input;  
    wire [7:0] sigmoid_output;  

    // Compute weighted sum of inputs  
    assign weighted_sum = (feature1 * weight1) + (feature2 * weight2) + (feature3 * weight3);  
    // Sigmoid function input scaling  
    assign sigmoid_input = {4'b0000, weighted_sum}; // Scale to 16 bits for sigmoid  
    // Simple sigmoid approximation: sigmoid(x) = 1 / (1 + exp(-x))  
    // This can be approximated for our use case with some hardcoded logic.  
    assign sigmoid_output = (sigmoid_input > 16'd8) ? 8'd255 : 8'd0; // Threshold for sigmoid  
    // Determine predicted class based on sigmoid output  
    always @(*) begin  
        if (sigmoid_output == 8'd255)  
            predicted_class = 1'b1;  
        else  
            predicted_class = 1'b0;  
    end  
endmodule