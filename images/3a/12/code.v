module svm_classifier (  
    input wire [3:0] x1,      // 4-bit input for feature x1  
    input wire [3:0] x2,      // 4-bit input for feature x2  
    input wire [3:0] b,       // 4-bit input for bias b  
    output wire class          // Output class (0 or 1)  
);  
    // Fixed weights  
    localparam w1 = 4'b0011;  // Weight for x1  
    localparam w2 = 4'b0100;  // Weight for x2  
      
    wire signed [7:0] decision_value;  
      
    assign decision_value = (w1 * x1) + (w2 * x2) + b;  
    assign class = (decision_value > 0) ? 1'b1 : 1'b0;  
endmodule