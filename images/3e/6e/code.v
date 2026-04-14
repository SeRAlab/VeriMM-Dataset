module rnn_cell (  
    input clk,  
    input [3:0] x,  
    output reg [3:0] y  
);  
    reg [3:0] state;  
  
    always @(posedge clk) begin  
        state <= state + x; // Update state with the input  
        // Apply ReLU activation function  
        y <= (state > 4'b0000) ? state : 4'b0000;  
    end  
endmodule