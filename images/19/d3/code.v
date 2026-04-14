module svm_classifier(  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] w1,  
    input [7:0] w2,  
    output reg decision  
);  
    always @* begin  
        if ((w1 * x1 + w2 * x2) > 0)  
            decision = 1;  
        else  
            decision = 0;  
    end  
endmodule