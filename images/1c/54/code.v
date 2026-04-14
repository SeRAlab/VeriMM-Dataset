module svm_classifier(  
    input [7:0] x,  
    input [7:0] y,  
    input signed [7:0] m,  
    input signed [7:0] b,  
    output reg class  
);  

    always @(*) begin  
        if (y > (m * x + b))  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule