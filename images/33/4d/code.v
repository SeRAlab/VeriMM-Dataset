module dynamic_range_compressor (
    input wire clk,
    input wire reset,
    input wire [7:0] input_signal,
    input wire control_signal,
    output reg [7:0] output_signal
);
    parameter COMPRESSION_RATIO = 4; // Compression ratio (1:4)
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 8'b0;
        end else begin
            if (control_signal) begin
                // Apply compression
                output_signal <= input_signal / COMPRESSION_RATIO;
            end else begin
                // Bypass
                output_signal <= input_signal;
            end
        end
    end
endmodule