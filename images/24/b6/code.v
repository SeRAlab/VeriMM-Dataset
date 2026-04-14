module fft_32_point (
    input clk,
    input rst,
    input enable,
    input [31:0] data_in,
    output reg [31:0] data_out
);
    // FFT implementation, simplified for this example
    reg [31:0] memory [0:31]; // Memory to store FFT inputs
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 32'b0;
            // Clear memory
            for (i = 0; i < 32; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (enable) begin
            // Simple pass-through for this example
            data_out <= data_in; // Replace with actual FFT computation
            // Store input data in memory for processing (if needed)
        end
    end
endmodule