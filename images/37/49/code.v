module iir_filter (
    input clk,
    input reset,
    input [15:0] input_sample,
    output reg [15:0] output_sample
);
    reg [15:0] x1, x2; // Previous input samples
    reg [15:0] y1, y2; // Previous output samples
    
    parameter [15:0] b0 = 16'h0001; // Coefficient b0
    parameter [15:0] b1 = 16'h0002; // Coefficient b1
    parameter [15:0] b2 = 16'h0003; // Coefficient b2
    parameter [15:0] a1 = 16'h0004; // Coefficient a1
    parameter [15:0] a2 = 16'h0005; // Coefficient a2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            output_sample <= 0;
        end else begin
            output_sample <= b0 * input_sample + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
            // Update previous samples
            x2 <= x1;
            x1 <= input_sample;
            y2 <= y1;
            y1 <= output_sample;
        end
    end
endmodule