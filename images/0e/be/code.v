module rnn_inference (  
    input [7:0] x,         // Input vector  
    input [7:0] h_in,      // Previous hidden state  
    output reg [7:0] h_out  // Updated hidden state  
);  
    reg [15:0] w;          // Weight matrix (simplified to a single value for this example)  
    always @(x or h_in) begin  
        w = 8'd2;          // Example weight  
        h_out = (h_in * w + x) > 8'd255 ? 8'd255 : (h_in * w + x); // Update hidden state with tanh approximation  
    end  
endmodule