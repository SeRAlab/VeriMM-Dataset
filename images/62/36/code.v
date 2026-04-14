module edge_detector(
    input clk,    // Chip clock signal.
    input in,     // Input signal to detect edges.
    
    output reg edge_detected  // Output signal that indicates a rising edge has been detected.
);

reg in_prev;  // Register to store the previous state of the input signal

//------------------------------------------------
// Edge detector logic
always @(posedge clk) begin
    edge_detected <= in & ~in_prev;  // Detect rising edge
    in_prev <= in;  // Update the previous state
end

endmodule