module svm_classifier (  
    input [7:0] x1,  
    input [7:0] x2,  
    input signed [7:0] w1,  
    input signed [7:0] w2,  
    input signed [7:0] b,  
    output reg class  
);  
    always @(*) begin  
        if ((w1 * x1 + w2 * x2 + b) > 0)  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule