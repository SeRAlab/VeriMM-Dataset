module svm_classifier(  
    input wire x1,  
    input wire x2,  
    output wire y  
);  
    assign y = (2*x1 + x2 > 1) ? 1 : 0;  
endmodule