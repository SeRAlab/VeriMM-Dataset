module rnn_cell (  
    input clk,  
    input [3:0] x,  // 4-bit input  
    output reg [3:0] h  // 4-bit hidden state  
);  
    // Weight matrix (4x4) - for simplicity, let's take specific values  
    reg [3:0] W [0:3];  
    initial begin  
        W[0] = 4'b0001;  
        W[1] = 4'b0010;  
        W[2] = 4'b0011;  
        W[3] = 4'b0100;  
    end  

    always @(posedge clk) begin  
        h <= W[0] * x[0] + W[1] * x[1] + W[2] * x[2] + W[3] * x[3] + h;  
    end  
endmodule