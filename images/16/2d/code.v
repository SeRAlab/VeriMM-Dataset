module fir_filter (
    input clk,
    input rst,
    input [3:0] x,  // 4-bit input
    output reg [3:0] y  // 4-bit output
);
    reg [3:0] x_reg [0:3];  // Shift register for inputs
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                x_reg[i] <= 4'b0000;  // Reset shift register
            end
            y <= 4'b0000;  // Reset output
        end else begin
            // Shift inputs in the register
            x_reg[3] <= x_reg[2];
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;

            // Calculate output using coefficients [1, 2, 3, 4]
            y <= (x_reg[0] * 1) + (x_reg[1] * 2) + (x_reg[2] * 3) + (x_reg[3] * 4);
        end
    end
endmodule