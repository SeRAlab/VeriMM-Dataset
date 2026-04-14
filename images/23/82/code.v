module fir_filter (
    input clk,
    input rst,
    input [3:0] x, // 4-bit input sample
    output reg [7:0] y // 8-bit output result to accommodate accumulation
);
    reg [3:0] coeff [0:3]; // Coefficients for the FIR filter
    reg [3:0] shift_reg [0:3]; // Shift register to hold samples

    initial begin
        coeff[0] = 4'b0001; // Coefficient 1
        coeff[1] = 4'b0010; // Coefficient 2
        coeff[2] = 4'b0011; // Coefficient 3
        coeff[3] = 4'b0100; // Coefficient 4
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 8'b0;
            shift_reg[0] <= 4'b0;
            shift_reg[1] <= 4'b0;
            shift_reg[2] <= 4'b0;
            shift_reg[3] <= 4'b0;
        end else begin
            // Shift the samples
            shift_reg[3] <= shift_reg[2];
            shift_reg[2] <= shift_reg[1];
            shift_reg[1] <= shift_reg[0];
            shift_reg[0] <= x;

            // Calculate the output
            y <= (shift_reg[0] * coeff[0]) + 
                 (shift_reg[1] * coeff[1]) + 
                 (shift_reg[2] * coeff[2]) + 
                 (shift_reg[3] * coeff[3]);
        end
    end
endmodule