module simple_rnn_cell (  
    input clk,  
    input reset,  
    input [7:0] x, // Input vector  
    output reg [7:0] h // Hidden state output  
);  
    reg [7:0] h_prev; // Previous hidden state  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            h <= 8'b0;  
            h_prev <= 8'b0;  
        end else begin  
            h <= (h_prev + x) > 8'b11111111 ? 8'b11111111 : (h_prev + x); // Linear transformation capped at max value  
            h_prev <= h;  
        end  
    end  
endmodule