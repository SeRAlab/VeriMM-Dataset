module rnn_unit (  
    input clk,  
    input [7:0] x,  
    input [7:0] h_prev,  
    input [7:0] w,  
    output reg [7:0] h  
);  
    wire signed [15:0] product;  
    wire signed [15:0] sum;  
    wire signed [15:0] tanh_out;  

    // Compute product w * x  
    assign product = w * x;  
    // Compute sum w * x + h_prev  
    assign sum = product + h_prev;  
    // Simple approximation of tanh using a sigmoid function  
    assign tanh_out = (sum > 0) ? sum : -sum; // Simplified tanh approximation  

    always @(posedge clk) begin  
        h <= tanh_out[7:0]; // Assign the output h  
    end  
endmodule