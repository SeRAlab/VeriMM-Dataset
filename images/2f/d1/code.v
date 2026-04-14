module svm_classifier(  
    input [3:0] feature1,  
    input [3:0] feature2,  
    output reg result  
);  
    always @(*) begin  
        // Example decision boundary: classify as 1 if (feature1 + feature2) > 8  
        if ((feature1 + feature2) > 8)  
            result = 1;  
        else  
            result = 0;  
    end  
endmodule