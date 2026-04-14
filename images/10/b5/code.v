module chebyshev_filter (
    input wire clk,
    input wire ctrl,
    input wire [7:0] x, // 8-bit input signal
    output reg [7:0] y   // 8-bit output signal
);
    reg [7:0] a0 = 8'd1; // Coefficient for x[n]
    reg [7:0] a1 = 8'd2; // Coefficient for x[n-1]
    reg [7:0] a2 = 8'd1; // Coefficient for x[n-2]
    reg [7:0] x1, x2;    // Previous inputs
    always @(posedge clk) begin
        x2 <= x1;      // Shift register for previous inputs
        x1 <= x;      // Current input
        if (ctrl) begin
            y <= (a0 * x + a1 * x1 + a2 * x2) >> 2;  // Simplified filter formula
        end else begin
            y <= x;  // Pass-through if ctrl is low
        end
    end
endmodule