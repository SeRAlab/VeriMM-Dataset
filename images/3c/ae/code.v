module rnn_cell #(parameter WIDTH = 4) (  
    input wire clk,  
    input wire rst,  
    input wire [WIDTH-1:0] x, // input vector  
    input wire [WIDTH-1:0] h_prev, // previous hidden state  
    output reg [WIDTH-1:0] h_new // new hidden state  
);  
    // Weights for input and hidden state (for simplicity, using fixed weights)  
    reg [WIDTH-1:0] Wxh = 4'b1010; // weights for input  
    reg [WIDTH-1:0] Whh = 4'b1100; // weights for hidden state  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            h_new <= 0;  
        end else begin  
            // Calculate the new hidden state  
            h_new <= (x * Wxh) + (h_prev * Whh);  
        end  
    end  
endmodule