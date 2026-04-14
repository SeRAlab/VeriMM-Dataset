module chebyshev_filter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [15:0] x_in,
    output reg [15:0] y_out
);
    parameter [15:0] b0 = 16'h1C71;  // Coefficients for the filter
    parameter [15:0] b1 = 16'h2A00;
    parameter [15:0] b2 = 16'h1C71;
    parameter [15:0] a1 = 16'hE92B;
    parameter [15:0] a2 = 16'h7C7E;

    reg [15:0] x_delay [0:2]; // Delay elements
    reg [15:0] y_delay [0:1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'h0000;
            x_delay[0] <= 16'h0000;
            x_delay[1] <= 16'h0000;
            x_delay[2] <= 16'h0000;
            y_delay[0] <= 16'h0000;
            y_delay[1] <= 16'h0000;
        end else if (enable) begin
            // Shift input samples through the delay line
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x_in;

            y_out <= (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] - a1 * y_delay[0] - a2 * y_delay[1]) >> 15;

            // Shift output samples through the delay line
            y_delay[1] <= y_delay[0];
            y_delay[0] <= y_out;
        end
    end
endmodule