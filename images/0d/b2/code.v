module svm_classifier (  
    input wire feature1,  
    input wire feature2,  
    input wire feature3,  
    output wire classification  
);  
    assign classification = (feature1 + feature2 + feature3) > 1 ? 1'b1 : 1'b0;  
endmodule