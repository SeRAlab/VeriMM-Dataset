module butterworth_filter (
    input [4:0] x,
    output [4:0] y
);
    wire [4:0] w1, w2, w3, w4;

    // Stage 1
    assign w1 = (x + 0) >> 1; // First stage (simple averaging)
    assign w2 = (w1 + w1) >> 1; // Second stage (simple averaging)
    
    // Stage 2
    assign w3 = (w2 + 0) >> 1; // Third stage (simple averaging)
    assign w4 = (w3 + w3) >> 1; // Fourth stage (simple averaging)

    // Final output
    assign y = w4;

endmodule