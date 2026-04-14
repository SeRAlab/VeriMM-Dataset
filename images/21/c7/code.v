module rnn_cell (  
    input clk,  
    input rst,  
    input [3:0] x,  // input vector  
    output reg [3:0] h  // hidden state  
);  
    reg [3:0] h_prev;  // previous hidden state  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h <= 4'b0000;  
            h_prev <= 4'b0000;  
        end else begin  
            h <= h_prev + x;  // update hidden state  
            h_prev <= h;  // store current hidden state for next cycle  
        end  
    end  
endmodule