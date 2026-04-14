module logistic_regression(  
    input wire x1,  
    input wire x2,  
    output wire y  
);  
    wire [1:0] weights;  
    wire weighted_sum;  
    
    assign weights = {2'b01}; // Example weights (w1 = 1, w2 = 0)  
    assign weighted_sum = (x1 * weights[1]) + (x2 * weights[0]);  
    assign y = (weighted_sum > 1) ? 1 : 0; // Simple threshold function for output  
endmodule