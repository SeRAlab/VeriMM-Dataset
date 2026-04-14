module rnn_inference (  
    input clk,  
    input rst,  
    input [3:0] seq_in,  
    output reg out  
);  
    reg [3:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 4'b0000;  
            out <= 0;  
        end else begin  
            state <= seq_in;  
            out <= (state[1] & state[0]);  
        end  
    end  
endmodule