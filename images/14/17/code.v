module fir_filter (
    input [3:0] x,      // 4-bit input sample
    input clk,
    output reg [4:0] y  // 5-bit output result
);

reg [3:0] x_buf[0:3]; // Buffer for the last 4 samples
integer i;

always @(posedge clk) begin
    // Shift the buffer
    x_buf[3] <= x_buf[2];
    x_buf[2] <= x_buf[1];
    x_buf[1] <= x_buf[0];
    x_buf[0] <= x;

    // Compute the output using coefficients {1, 2, 3, 4}
    y <= (1 * x_buf[0]) + (2 * x_buf[1]) + (3 * x_buf[2]) + (4 * x_buf[3]);
end

endmodule