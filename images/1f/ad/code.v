module rnn_cell(clk, rst, x, h_prev, h_out);  
    input clk;  
    input rst;  
    input [4:0] x;      // Current input (5 bits)  
    input [4:0] h_prev; // Previous state (5 bits)  
    output reg [4:0] h_out; // Current state (5 bits)  
  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            h_out <= 5'b00000; // Reset state to zero  
        else  
            h_out <= h_prev + x; // Simple update rule  
    end  
endmodule