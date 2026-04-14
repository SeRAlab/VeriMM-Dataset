module fir_filter (
    input [15:0] x, // 16-bit input signal
    input clk,
    output reg [31:0] y // 32-bit output signal
);
    reg [15:0] shift_reg [0:15]; // Shift register for storing input samples
    reg [31:0] coeff[0:15]; // Coefficients
    integer i;

    initial begin
        // Define fixed coefficients
        coeff[0] = 32'h0001;
        coeff[1] = 32'h0002;
        coeff[2] = 32'h0003;
        coeff[3] = 32'h0004;
        coeff[4] = 32'h0005;
        coeff[5] = 32'h0006;
        coeff[6] = 32'h0007;
        coeff[7] = 32'h0008;
        coeff[8] = 32'h0009;
        coeff[9] = 32'h000A;
        coeff[10] = 32'h000B;
        coeff[11] = 32'h000C;
        coeff[12] = 32'h000D;
        coeff[13] = 32'h000E;
        coeff[14] = 32'h000F;
        coeff[15] = 32'h0010;
    end

    always @(posedge clk) begin
        // Shift the input samples
        for (i = 15; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= x;

        // Compute the output y
        y <= 0;
        for (i = 0; i < 16; i = i + 1) begin
            y <= y + (shift_reg[i] * coeff[i]);
        end
    end
endmodule