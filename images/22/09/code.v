module butterworth_filter(
    input clk,
    input reset,
    input [7:0] in_signal,
    output reg [7:0] out_signal
);
    // Define the coefficients for a 4th order Butterworth filter (example values)
    parameter [7:0] b0 = 8'd16; // Coefficient for the current input
    parameter [7:0] b1 = 8'd32; // Coefficient for the first previous input
    parameter [7:0] b2 = 8'd16; // Coefficient for the second previous input
    parameter [7:0] a1 = 8'd48; // Coefficient for the first output
    parameter [7:0] a2 = 8'd24; // Coefficient for the second output

    // Shift registers to hold previous inputs and outputs
    reg [7:0] x[0:2]; // x[n], x[n-1], x[n-2]
    reg [7:0] y[0:1]; // y[n-1], y[n-2]

    // Initialize the filter
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_signal <= 8'd0;
            for (i = 0; i < 3; i = i + 1) x[i] <= 8'd0;
            for (i = 0; i < 2; i = i + 1) y[i] <= 8'd0;
        end else begin
            // Shift the input values
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= in_signal;

            // Shift the output values
            y[1] <= y[0];

            // Calculate the filtered output
            out_signal <= (b0 * x[0] + b1 * x[1] + b2 * x[2] - a1 * y[0] - a2 * y[1]) >> 5; // Right shift for normalization
            y[0] <= out_signal;
        end
    end
endmodule