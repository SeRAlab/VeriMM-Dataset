module simple_nn (  
    input clk,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] target,  
    output reg [7:0] output_y  
);  
    reg [7:0] w1_1, w1_2;  // weights from input layer to hidden layer  
    reg [7:0] w2_1, w2_2;  // weights from hidden layer to output layer  
    reg [7:0] hidden1, hidden2;  
    reg [7:0] output_temp;  
    reg [7:0] learning_rate = 8'd1;  

    // Initialize weights  
    initial begin  
        w1_1 = 8'd1;  
        w1_2 = 8'd1;  
        w2_1 = 8'd1;  
        w2_2 = 8'd1;  
    end  

    // Forward Propagation  
    always @(posedge clk) begin  
        hidden1 <= (x1 * w1_1) + (x2 * w1_2);  
        hidden2 <= (x1 * w1_1) + (x2 * w1_2);  
        output_temp <= (hidden1 * w2_1) + (hidden2 * w2_2);  
        output_y <= output_temp;  
    end  

    // Backpropagation  
    always @(posedge clk) begin  
        // Simple weight update rule  
        w2_1 <= w2_1 + (learning_rate * (target - output_temp) * hidden1);  
        w2_2 <= w2_2 + (learning_rate * (target - output_temp) * hidden2);  
        w1_1 <= w1_1 + (learning_rate * (target - output_temp) * w2_1 * x1);  
        w1_2 <= w1_2 + (learning_rate * (target - output_temp) * w2_2 * x2);  
    end  
endmodule