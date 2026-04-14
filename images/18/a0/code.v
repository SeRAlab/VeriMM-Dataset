module iir_filter (
    input clk,
    input rst,
    input [15:0] x,      // Input sample
    output reg [15:0] y  // Output sample
);
    reg [15:0] y_prev;   // Previous output
    parameter [15:0] a0 = 16'h0001; // Example coefficient a0
    parameter [15:0] a1 = 16'h0001; // Example coefficient a1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            y_prev <= 16'b0;
        end else begin
            y <= (a0 * x + a1 * y_prev) >> 16; // Shift to avoid overflow
            y_prev <= y; // Store current output for next cycle
        end
    end
endmodule