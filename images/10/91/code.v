module neuron_backpropagation(input clk,  
                              input [7:0] X1,  
                              input [7:0] X2,  
                              input [7:0] W1,  
                              input [7:0] W2,  
                              input [7:0] B,  
                              input [7:0] T,  
                              input [7:0] LR,  
                              output reg [7:0] O,  
                              output reg [7:0] W1_out,  
                              output reg [7:0] W2_out,  
                              output reg [7:0] B_out);  

    reg [7:0] Z;  
    reg [7:0] sigmoid;  
    reg [7:0] error;  
    reg [7:0] dW1, dW2, dB;  

    always @(posedge clk) begin  
        Z <= (X1 * W1 + X2 * W2 + B);  
        sigmoid <= (Z > 0) ? (Z / (Z + 256)) : 0;  // Simplified sigmoid function for 8-bit  
        error <= T - sigmoid;  

        // Calculate gradients  
        dW1 <= (error * X1) * LR;  
        dW2 <= (error * X2) * LR;  
        dB <= error * LR;  

        // Update weights and bias  
        W1_out <= W1 + dW1;  
        W2_out <= W2 + dW2;  
        B_out <= B + dB;  
        O <= sigmoid;  
    end  
endmodule