module rnn_cell (  
    input clk,  
    input rst,  
    input [7:0] x,      // Current input  
    input [7:0] h_prev, // Previous hidden state  
    output reg [7:0] h   // Next hidden state  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            h <= 8'b0;  
        else  
            h <= (h_prev + x > 8'd255) ? 8'd255 : (h_prev + x); // ReLU Activation  
    end  
endmodule