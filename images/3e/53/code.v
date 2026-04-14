module rnn_cell (  
    input [3:0] x,        // Input vector  
    input [3:0] h_prev,   // Previous hidden state  
    output reg [3:0] h_new // New hidden state  
);  
    // Weights  
    reg [3:0] W_x = 4'b1010; // Example weights for input  
    reg [3:0] W_h = 4'b1100; // Example weights for hidden state  
      
    always @(*) begin  
        // Compute the new hidden state as a simple example  
        h_new = (W_x & x) + (W_h & h_prev);  
    end  
endmodule