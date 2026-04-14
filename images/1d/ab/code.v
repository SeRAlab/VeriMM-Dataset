module rnn_cell (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] x,  
    output reg [4:0] y  
);  
    reg [4:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 5'b0;  
            y <= 5'b0;  
        end else begin  
            // Simple linear transformation and ReLU activation  
            state <= state + x;  
            y <= (state > 5'b0) ? state : 5'b0;  
        end  
    end  
endmodule