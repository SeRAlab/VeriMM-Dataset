module temperature_shutdown (
    input [4:0] temperature,  // 5-bit temperature input
    output shutdown           // shutdown signal
);
    parameter THRESHOLD = 5'd25;  // Example threshold temperature
    assign shutdown = (temperature > THRESHOLD) ? 1'b1 : 1'b0;  // Generate shutdown signal
endmodule