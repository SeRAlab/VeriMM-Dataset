module iir_filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    reg signed [15:0] x_delay [0:3]; // Delay line for input
    reg signed [15:0] y_delay [0:3]; // Delay line for output

    // Coefficients (scaled to fixed point)
    localparam signed [15:0] a0 = 16'h0001; // 1.0
    localparam signed [15:0] a1 = 16'hFC00; // -1.8
    localparam signed [15:0] a2 = 16'hD800; // 0.81
    localparam signed [15:0] b0 = 16'h0194; // 0.1
    localparam signed [15:0] b1 = 16'h0320; // 0.2
    localparam signed [15:0] b2 = 16'h04C8; // 0.3
    localparam signed [15:0] b3 = 16'h0660; // 0.4

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_out <= 16'h0000;
            for (i = 0; i < 4; i = i + 1) begin
                x_delay[i] <= 16'h0000;
                y_delay[i] <= 16'h0000;
            end
        end else begin
            // Shift the delays
            for (i = 3; i > 0; i = i - 1) begin
                x_delay[i] <= x_delay[i-1];
                y_delay[i] <= y_delay[i-1];
            end
            x_delay[0] <= x_in;

            // Calculate the output
            y_out <= (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] + b3 * x_delay[3]
                      - a1 * y_delay[1] - a2 * y_delay[2]);
            y_delay[0] <= y_out;
        end
    end
endmodule