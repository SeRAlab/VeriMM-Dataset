module rnn_inference (
    input wire [4:0] x,        // 5-bit input
    input wire [4:0] h_prev,   // 5-bit previous hidden state
    output reg [4:0] h_next    // 5-bit next hidden state
);
    // Weights for the linear transformation (for simplicity, using small fixed values)
    wire [4:0] w1 = 5'b00011; // Example weight for input
    wire [4:0] w2 = 5'b00010; // Example weight for hidden state

    // Compute the next hidden state
    always @(x, h_prev) begin
        // Linear transformation
        h_next = (x * w1) + (h_prev * w2);
        // Apply ReLU activation
        if (h_next < 5'b00000)
            h_next = 5'b00000; // ReLU
    end
endmodule