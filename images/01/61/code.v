module simple_rnn #(parameter WIDTH = 8,  
                    parameter HIDDEN_SIZE = 4)  
(  
    input wire clk,  
    input wire rst,  
    input wire [WIDTH-1:0] X,  
    input wire [HIDDEN_SIZE-1:0] H_old,  
    output reg [HIDDEN_SIZE-1:0] H_new  
);  

// Weight and bias parameters
reg [WIDTH-1:0] W [0:HIDDEN_SIZE-1];  
reg [HIDDEN_SIZE-1:0] U [0:HIDDEN_SIZE-1];  
reg [HIDDEN_SIZE-1:0] b;  

// Internal signal for computation
reg [HIDDEN_SIZE-1:0] sum;  
integer i;  

initial begin  
    // Initialize weights and bias (example values)
    W[0] = 8'd1; W[1] = 8'd2; W[2] = 8'd3; W[3] = 8'd4;  
    U[0] = 8'd1; U[1] = 8'd1; U[2] = 8'd1; U[3] = 8'd1;  
    b = 4'd1;  
end  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        H_new <= 0;  
    end else begin  
        sum = 0;  
        for (i = 0; i < HIDDEN_SIZE; i = i + 1) begin  
            sum = sum + W[i] * X + U[i] * H_old[i];  
        end  
        H_new <= tanh(sum + b);  
    end  
end  

function [HIDDEN_SIZE-1:0] tanh;  
    input [HIDDEN_SIZE-1:0] x;  
    begin  
        // Simple tanh approximation  
        if (x > 4) 
            tanh = 4;  
        else if (x < -4) 
            tanh = -4;  
        else 
            tanh = x;  
    end  
endfunction  

endmodule