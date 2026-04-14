module svm_classifier (  
    input [7:0] feature1,  
    input [7:0] feature2,  
    output reg class_label  
);  
    reg signed [15:0] weight1 = 3;  
    reg signed [15:0] weight2 = 5;  
    reg signed [15:0] bias = -20;  
    reg signed [15:0] decision_value;  

    always @* begin  
        decision_value = (feature1 * weight1) + (feature2 * weight2) + bias;  
        if (decision_value >= 0)  
            class_label = 1;  
        else  
            class_label = 0;  
    end  
endmodule