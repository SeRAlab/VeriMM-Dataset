module rnn_cell (  
    input clk,  
    input rst,  
    input [3:0] x, // input  
    output reg y,   // output  
    output reg [3:0] h // hidden state  
);  
    parameter THRESHOLD = 4;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h <= 4'b0000;  
            y <= 1'b0;  
        end else begin  
            h <= x + h;  
            y <= (h > THRESHOLD) ? 1'b1 : 1'b0;  
        end  
    end  
endmodule