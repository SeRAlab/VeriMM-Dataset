module svm_classifier(  
    input [7:0] x,  
    input [7:0] y,  
    output reg class  
);  
    parameter W0 = 3;  
    parameter W1 = 2;  
    parameter B = -5;  

    always @(*) begin  
        if (W0*x + W1*y + B > 0)  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule