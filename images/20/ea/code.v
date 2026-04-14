module SVM_Decision(
    input [4:0] x1, // Feature vector 1
    input [4:0] x2, // Feature vector 2
    output reg decision // Output decision
);
    parameter w1 = 5'b00001; // Weight w1
    parameter w2 = 5'b00001; // Weight w2
    parameter b = 5'b00001;   // Bias term

    always @(*) begin
        // Calculate the decision function
        if ((w1 * x1 + w2 * x2 + b) > 5'b00000) 
            decision = 1; // Class 1
        else 
            decision = 0; // Class 0
    end
endmodule