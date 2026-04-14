module fir_filter (
    input [3:0] x,
    input clk,
    input rst,
    output reg [7:0] y
);
    reg [3:0] x_reg [0:4];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 5; i = i + 1) begin
                x_reg[i] <= 4'b0000;
            end
            y <= 8'b00000000;
        end else begin
            // Shift the samples
            x_reg[0] <= x;
            for (i = 1; i < 5; i = i + 1) begin
                x_reg[i] <= x_reg[i-1];
            end
            // Apply FIR filter coefficients
            y <= (1 * x_reg[0]) + (2 * x_reg[1]) + (3 * x_reg[2]) + (4 * x_reg[3]) + (5 * x_reg[4]);
        end
    end
endmodule