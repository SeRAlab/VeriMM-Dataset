module rnn_cell(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] input_vector,  
    input wire [7:0] hidden_state,  
    output reg [7:0] next_hidden_state  
);  
    reg [7:0] W [0:3];  // weights for input  
    reg [7:0] U [0:3];  // weights for hidden state  
    reg [7:0] b;        // bias  
    integer i;  
    initial begin  
        // Initialize weights and bias  
        W[0] = 8'd1; W[1] = 8'd2; W[2] = 8'd3; W[3] = 8'd4;  
        U[0] = 8'd1; U[1] = 8'd1; U[2] = 8'd1; U[3] = 8'd1;  
        b = 8'd1;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_hidden_state <= 8'd0;  
        end else begin  
            // Calculate next hidden state  
            next_hidden_state <= tanh(W[0] * input_vector +  
                                       W[1] * input_vector +  
                                       W[2] * hidden_state +  
                                       W[3] * hidden_state +  
                                       b);  
        end  
    end  

    // Simple tanh approximation  
    function [7:0] tanh;  
        input [15:0] x;  
        begin  
            if (x > 16'd0)  
                tanh = x[7:0];  
            else  
                tanh = -x[7:0];  
        end  
    endfunction  
endmodule