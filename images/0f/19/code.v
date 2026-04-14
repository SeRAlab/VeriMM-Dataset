module logistic_regression(  
    input [3:0] feature1,  
    input [3:0] feature2,  
    output reg class_out  
);  
    // Predefined weights  
    localparam weight1 = 4'b0101; // weight for feature1  
    localparam weight2 = 4'b0011; // weight for feature2  
    
    wire [7:0] weighted_sum;  
    wire [7:0] sigmoid_output;  
    
    // Calculate weighted sum  
    assign weighted_sum = (feature1 * weight1) + (feature2 * weight2);  
    
    // Sigmoid function approximation  
    assign sigmoid_output = (weighted_sum > 8'd10) ? 1 : 0; // threshold for classification  
    
    always @(*) begin  
        class_out = sigmoid_output;  
    end  
endmodule