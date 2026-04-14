module svm_decision (  
    input wire x1,  
    input wire x2,  
    output wire class  
);  
    assign class = (x1 + x2) > 1;  
endmodule