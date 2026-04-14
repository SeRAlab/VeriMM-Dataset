module svm_classifier (  
    input wire [3:0] x1,  
    input wire [3:0] x2,  
    output wire class  
);  
    assign class = (x1 + 2 * x2) > 3 ? 1 : 0;  
endmodule