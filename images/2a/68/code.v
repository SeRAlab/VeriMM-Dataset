module rnn_cell(  
    input clk,  
    input [3:0] x,  
    input [3:0] h_prev,  
    output reg [3:0] h_new  
);  

    wire [3:0] w1 = 4'b0001; // Weights for the input  
    wire [3:0] w2 = 4'b0010; // Weights for the previous hidden state  

    always @(posedge clk) begin  
        h_new <= (x * w1) + (h_prev * w2); // Simple linear transformation  
    end  
endmodule