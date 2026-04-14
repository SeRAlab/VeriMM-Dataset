module rnn_cell (  
    input clk,  
    input rst,  
    input [3:0] x,  // input  
    input [3:0] h_in,  // previous hidden state  
    output reg [3:0] h_out  // new hidden state  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h_out <= 4'b0000;  
        end else begin  
            // Add input and previous hidden state  
            h_out <= (x + h_in > 4'b1111) ? 4'b1111 : (x + h_in);  // Saturate at 15  
            // Apply ReLU (which is inherently done with unsigned addition)  
        end  
    end  
endmodule