module rnn_inference (  
    input clk,  
    input rst,  
    input [4:0] x,  
    output reg [4:0] state  
);  
    parameter weight = 5'b00011; // Weight multiplier (3)  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= 5'b00000;  
        else  
            state <= (state * weight) + x;  
    end  
endmodule