module svm_classifier (  
    input signed [7:0] x1,  
    input signed [7:0] x2,  
    output reg y  
);  
    // Define weights and bias  
    parameter signed [7:0] w1 = 8'd3;  
    parameter signed [7:0] w2 = 8'd2;  
    parameter signed [7:0] b = 8'd1;  

    always @* begin  
        // Calculate decision boundary  
        if ((w1 * x1 + w2 * x2 + b) > 0)  
            y = 1;  
        else  
            y = 0;  
    end  
endmodule