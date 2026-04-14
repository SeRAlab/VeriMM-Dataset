module IIR_Filter (
    input clk,
    input rst,
    input [15:0] in0,
    input [15:0] in1,
    output reg [15:0] out
);
    reg [15:0] x [0:4]; // Input buffer
    reg [15:0] y [0:4]; // Output buffer
    parameter b0 = 16'd1638; // 0.1 * 16384
    parameter b1 = 16'd3277; // 0.2 * 16384
    parameter b2 = 16'd4915; // 0.3 * 16384
    parameter b3 = 16'd6554; // 0.4 * 16384
    parameter b4 = 16'd8192; // 0.5 * 16384
    parameter a1 = 16'd9830; // 0.6 * 16384
    parameter a2 = 16'd11469; // 0.7 * 16384
    parameter a3 = 16'd13107; // 0.8 * 16384
    parameter a4 = 16'd14746; // 0.9 * 16384

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
            x[0] <= 0; x[1] <= 0; x[2] <= 0; x[3] <= 0; x[4] <= 0;
            y[0] <= 0; y[1] <= 0; y[2] <= 0; y[3] <= 0; y[4] <= 0;
        end else begin
            // Shift input values
            x[4] <= x[3];
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= in0 + in1;

            // Compute output
            y[4] <= y[3];
            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];
            y[0] <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4] - 
                      a1 * y[1] - a2 * y[2] - a3 * y[3] - a4 * y[4]) >> 14;

            out <= y[0];
        end
    end
endmodule