module fir_filter (
    input [3:0] x,
    output reg [3:0] y
);
    reg [3:0] coeff [0:3]; // Coefficients
    reg [3:0] shift_reg [0:3]; // Shift register

    initial begin
        coeff[0] = 4'b0001; // Coefficient 1
        coeff[1] = 4'b0010; // Coefficient 2
        coeff[2] = 4'b0011; // Coefficient 3
        coeff[3] = 4'b0100; // Coefficient 4
    end

    always @(*) begin
        shift_reg[0] = x; // New input
        shift_reg[1] = shift_reg[0]; // Shift
        shift_reg[2] = shift_reg[1]; // Shift
        shift_reg[3] = shift_reg[2]; // Shift

        // Calculate the output
        y = (coeff[0] * shift_reg[0]) + 
            (coeff[1] * shift_reg[1]) + 
            (coeff[2] * shift_reg[2]) + 
            (coeff[3] * shift_reg[3]);
    end
endmodule