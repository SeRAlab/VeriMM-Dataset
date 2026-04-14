module FIR_filter(
    input clk,
    input reset,
    input [3:0] x, // 4-bit input signal
    output reg [7:0] y // 8-bit output signal
);
    reg [3:0] x_reg [0:3]; // Shift registers for input
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 8'b0;
            for (i = 0; i < 4; i = i + 1) begin
                x_reg[i] <= 4'b0;
            end
        end else begin
            // Shift the input signals
            x_reg[3] <= x_reg[2];
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;

            // Calculate output using fixed coefficients
            y <= (x_reg[0] * 1) + (x_reg[1] * 2) + (x_reg[2] * 3) + (x_reg[3] * 4);
        end
    end
endmodule