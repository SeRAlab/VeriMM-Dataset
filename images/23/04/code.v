module chebyshev_filter(
    input wire clk,
    input wire rst,
    input wire [3:0] x_in, // 4-bit input signal
    output reg [3:0] y_out // 4-bit output signal
);
    reg [3:0] x1, x2; // previous inputs
    reg [3:0] y1, y2; // previous outputs
    parameter A1 = 4'b0001; // Coefficients for Chebyshev filter
    parameter A2 = 4'b0010;
    parameter B1 = 4'b0001;
    parameter B2 = 4'b0001;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 4'b0000;
            x2 <= 4'b0000;
            y1 <= 4'b0000;
            y2 <= 4'b0000;
            y_out <= 4'b0000; // reset output
        end else begin
            // State update
            y_out <= A1 * x_in + A2 * x1 - B1 * y1 - B2 * y2;
            x2 <= x1; // Shift previous inputs
            x1 <= x_in;
            y2 <= y1; // Shift previous outputs
            y1 <= y_out;
        end
    end
endmodule