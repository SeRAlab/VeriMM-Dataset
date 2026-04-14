module svm_classifier(  
    input [2:0] features,  
    output reg class  
);  
    always @(*) begin  
        // weights and bias  
        if (features[2] - features[1] + features[0] > 0)  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule