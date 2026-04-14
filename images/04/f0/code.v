module svm_classifier (  
    input signed [7:0] x1,  
    input signed [7:0] x2,  
    output reg class  
);  
    parameter signed w1 = 2;  
    parameter signed w2 = -1;  
    parameter signed b = -1;  

    always @(*) begin  
        if ((w1 * x1 + w2 * x2 + b) > 0)  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule