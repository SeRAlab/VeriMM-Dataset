module fir_filter (
    input signed [3:0] x, // 4-bit input
    input clk,
    input rst,
    output reg signed [5:0] y // 6-bit output
);
    reg signed [3:0] x_delay [0:3]; // delay line
    parameter signed [3:0] h0 = 4'd1; // filter coefficients
    parameter signed [3:0] h1 = 4'd2;
    parameter signed [3:0] h2 = 4'd3;
    parameter signed [3:0] h3 = 4'd4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_delay[0] <= 4'd0;
            x_delay[1] <= 4'd0;
            x_delay[2] <= 4'd0;
            x_delay[3] <= 4'd0;
            y <= 6'd0;
        end else begin
            // Shift the input values
            x_delay[3] <= x_delay[2];
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x;

            // Calculate the output
            y <= (h0 * x_delay[0]) + (h1 * x_delay[1]) + (h2 * x_delay[2]) + (h3 * x_delay[3]);
        end
    end
endmodule