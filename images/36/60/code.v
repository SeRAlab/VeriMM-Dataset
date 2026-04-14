module fir_filter (
    input wire clk,
    input wire [15:0] x_in,
    output reg [15:0] y_out
);
    parameter COEFFS = {16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF, 16'h0FFF,
                        16'h0FFF, 16'h0FFF};

    reg [15:0] shift_reg [0:31];
    integer i;

    always @(posedge clk) begin
        // Shift input values into shift register
        for (i = 31; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        shift_reg[0] <= x_in;

        // Compute output using coefficients
        y_out <= 0;
        for (i = 0; i < 32; i = i + 1) begin
            y_out <= y_out + (shift_reg[i] * COEFFS[i]);
        end
    end
endmodule