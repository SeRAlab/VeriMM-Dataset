module rnn_cell (  
    input [3:0] x,  
    input [3:0] h_prev,  
    output reg [3:0] h_new  
);  
    always @(x, h_prev) begin  
        h_new = (x + h_prev) % 16;  
    end  
endmodule