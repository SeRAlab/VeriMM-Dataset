module svm_classifier (  
    input signed [7:0] x1,  
    input signed [7:0] x2,  
    input signed [7:0] b,  
    output reg class  
);  
    // Constants for weights  
    parameter signed [7:0] w1 = 8'b00011000; // Weight for feature x1  
    parameter signed [7:0] w2 = 8'b00010100; // Weight for feature x2  

    always @(*) begin  
        // Decision function  
        if ((w1 * x1 + w2 * x2 + b) > 0)  
            class = 1;  
        else  
            class = 0;  
    end  
endmodule