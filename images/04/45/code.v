module rnn_cell(  
    input clk,  
    input [4:0] x,          // Input vector  
    input [4:0] h_prev,     // Previous hidden state  
    input [24:0] w_in,      // Weight for input (5x5)  
    input [24:0] w_h,       // Weight for hidden state (5x5)  
    input [4:0] b,          // Bias  
    output reg [4:0] h_out  // Output hidden state  
);  
    reg [4:0] h_temp;  
    integer i;  

    always @(posedge clk) begin  
        h_temp = b;  
        for (i = 0; i < 5; i = i + 1) begin  
            h_temp = h_temp + ((x * w_in[i*5 +: 5]) + (h_prev * w_h[i*5 +: 5]));  
        end  
        // Hyperbolic tangent activation approximation  
        h_out = (h_temp > 0) ? 5'b11111 : 5'b00000; // simplified activation  
    end  
endmodule