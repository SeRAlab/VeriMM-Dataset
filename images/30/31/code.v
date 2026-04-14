module svm_classifier(  
    input [4:0] x1, // First feature  
    input [4:0] x2, // Second feature  
    output reg y     // Classification output  
);  
    // Weights and bias  
    parameter w1 = 5'b00011; // 3  
    parameter w2 = 5'b00010; // 2  
    parameter b = 5'b11101;   // -5 in 5-bit two's complement  

    always @(*) begin  
        // Compute the decision function  
        if ((w1 * x1 + w2 * x2) + b > 0)  
            y = 1;  
        else  
            y = 0;  
    end  
endmodule