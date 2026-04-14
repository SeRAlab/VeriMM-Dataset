module rnn_cell (  
    input wire [4:0] x,      // 5-bit input  
    input wire [4:0] h_prev, // 5-bit previous hidden state  
    output reg [4:0] h_new   // 5-bit new hidden state  
);  
    // Weight for input (fixed values for simplicity)  
    reg [4:0] w = 5'b00011;  // Example weight vector for input  
    integer i;  

    always @(x, h_prev) begin  
        // Compute new hidden state  
        h_new = h_prev;  
        for (i = 0; i < 5; i = i + 1) begin  
            // Simple multiplication and saturating ReLU  
            if (x[i] * w[i] + h_prev[i] > 31)  
                h_new[i] = 31;  
            else if (x[i] * w[i] + h_prev[i] < 0)  
                h_new[i] = 0;  
            else  
                h_new[i] = x[i] * w[i] + h_prev[i];  
        end  
    end  
endmodule