module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x, // input sample
    output reg signed [15:0] y // output sample
);
    // Filter coefficients
    parameter signed [15:0] b0 = 16'h1234;
    parameter signed [15:0] b1 = 16'h2345;
    parameter signed [15:0] b2 = 16'h3456;
    parameter signed [15:0] b3 = 16'h4567;
    parameter signed [15:0] b4 = 16'h5678;
    parameter signed [15:0] a1 = 16'h0001;
    parameter signed [15:0] a2 = 16'h0002;
    parameter signed [15:0] a3 = 16'h0003;
    parameter signed [15:0] a4 = 16'h0004;

    // State variables
    reg signed [15:0] z1, z2, z3, z4; // previous output states
    reg signed [15:0] x1, x2, x3, x4; // previous input states

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'b0;
            z1 <= 16'b0;
            z2 <= 16'b0;
            z3 <= 16'b0;
            z4 <= 16'b0;
            x1 <= 16'b0;
            x2 <= 16'b0;
            x3 <= 16'b0;
            x4 <= 16'b0;
        end else begin
            // IIR filter equation
            y <= b0 * x + b1 * x1 + b2 * x2 + b3 * x3 + b4 * x4
                 - a1 * z1 - a2 * z2 - a3 * z3 - a4 * z4;

            // Update state variables
            z4 <= z3;
            z3 <= z2;
            z2 <= z1;
            z1 <= y;

            x4 <= x3;
            x3 <= x2;
            x2 <= x1;
            x1 <= x;
        end
    end
endmodule