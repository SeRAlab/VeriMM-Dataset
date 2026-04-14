module svm_classifier (  
    input wire [3:0] x1,  
    input wire [3:0] x2,  
    output wire result  
);  
    assign result = (2 * x1 + 3 * x2 > 5) ? 1'b1 : 1'b0;  
endmodule