module fir_filter(
    input [7:0] x,              // 8-bit input
    input clk,                  // clock signal
    output reg [7:0] y          // 8-bit output
);
    reg [7:0] coeff[0:7];       // Coefficients for 8-tap FIR filter
    reg [7:0] shift_reg[0:7];   // Shift register for input samples
    integer i;

    initial begin
        // Initialize coefficients (example values)
        coeff[0] = 8'd1;
        coeff[1] = 8'd2;
        coeff[2] = 8'd3;
        coeff[3] = 8'd4;
        coeff[4] = 8'd5;
        coeff[5] = 8'd6;
        coeff[6] = 8'd7;
        coeff[7] = 8'd8;
    end

    always @(posedge clk) begin
        // Shift the samples in the shift register
        for (i = 7; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        shift_reg[0] <= x;

        // Compute the filter output
        y <= 8'd0; // Initialize output
        for (i = 0; i < 8; i = i + 1) begin
            y <= y + (shift_reg[i] * coeff[i]);
        end
    end
endmodule