module svm_decision_function(  
    input [3:0] x1,  
    input [3:0] x2,  
    input [3:0] w1,  
    input [3:0] w2,  
    output reg y  
);  
    parameter b = 4; // bias term  
    wire signed [7:0] result;  
      
    assign result = (x1 * w1) + (x2 * w2) + b;  
      
    always @(*) begin  
        if (result > 0)  
            y = 1;  
        else  
            y = 0;  
    end  
endmodule