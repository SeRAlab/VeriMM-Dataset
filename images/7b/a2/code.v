module top_module(
    input clk,        // System clock
    input rst,        // Reset, active high and synchronous
    input en,         // Filter enable
    input signed [WIDTH-1:0] dataIn,  // [WIDTH-1:0] Filter input
    output signed [WIDTH-1:0] dataOut // [WIDTH-1:0] Filter output
);parameter K0_SHIFT = 5; // K0 filter term = 2^-K0_SHIFT
parameter K1_SHIFT = 5; // K1 filter term = 2^-K1_SHIFT
parameter WIDTH = 16;   // Width of data path
parameter CLAMP = 1;    // Set to 1 to clamp the accumulators

reg signed [WIDTH-1:0] x0; // Input sample at time n
reg signed [WIDTH-1:0] x1; // Input sample at time n-1
reg signed [WIDTH-1:0] y0; // Output sample at time n
reg signed [WIDTH-1:0] y1; // Output sample at time n-1
reg signed [WIDTH-1:0] y;   // Change y to reg to allow assignment in always block
reg signed [WIDTH+1:0] acc0; // Accumulator for K0 term
reg signed [WIDTH+1:0] acc1; // Accumulator for K1 term

always @(posedge clk) begin
    if (rst) begin
        x0 <= 'd0;
        x1 <= 'd0;
        y0 <= 'd0;
        y1 <= 'd0;
        acc0 <= 'd0;
        acc1 <= 'd0;
        y <= 'd0; // Initialize y on reset
    end else if (en) begin
        x1 <= x0;
        x0 <= dataIn;
        y1 <= y0;
        y0 <= y; // Update y0 with the current output value
        acc0 <= acc0 + (K0_SHIFT ? (x0 << K0_SHIFT) : x0);
        acc1 <= acc1 + (K1_SHIFT ? (x1 << K1_SHIFT) : x1) - (K0_SHIFT ? (y0 << K0_SHIFT) : y0);
        y <= acc0 - acc1; // Update y with the current calculated value
    end else begin
        y <= dataIn; // Update y directly with dataIn when not enabled
    end
end

assign dataOut = CLAMP ? ((y > (2**(WIDTH-1)-1)) ? (2**(WIDTH-1)-1) : ((y < -(2**(WIDTH-1))) ? -(2**(WIDTH-1)) : y)) : y;

endmodule