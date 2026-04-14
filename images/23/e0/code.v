module logistic_regression (  
    input [7:0] feature1,  
    input [7:0] feature2,  
    input [7:0] feature3,  
    output reg prediction  
);  
    wire [15:0] weighted_sum;  
    parameter weight1 = 3;  
    parameter weight2 = 2;  
    parameter weight3 = 5;  
    parameter bias = 10;  
    assign weighted_sum = (feature1 * weight1) + (feature2 * weight2) + (feature3 * weight3) + bias;  
    always @(*) begin  
        if (weighted_sum >= 50)  
            prediction = 1;  
        else  
            prediction = 0;  
    end  
endmodule