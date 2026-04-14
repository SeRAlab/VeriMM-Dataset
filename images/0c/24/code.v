module fir_filter (
    input clk,
    input rst,
    input [15:0] x,       // Input sample
    output reg [15:0] y   // Output sample
);

reg [15:0] coeff[0:4];  // Coefficients of the FIR filter
reg [15:0] shift_reg[0:4]; // Shift register for storing input samples
reg [31:0] accumulator; // Accumulator for the filter output
integer i;

// Initializing the coefficients
initial begin
    coeff[0] = 16'h0001; // Coefficient 0
    coeff[1] = 16'h0002; // Coefficient 1
    coeff[2] = 16'h0003; // Coefficient 2
    coeff[3] = 16'h0004; // Coefficient 3
    coeff[4] = 16'h0005; // Coefficient 4
end

// Sequential block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        y <= 16'b0;
        accumulator <= 32'b0;
        for (i = 0; i < 5; i = i + 1) begin
            shift_reg[i] <= 16'b0;
        end
    end else begin
        // Shift the input samples
        shift_reg[4] <= shift_reg[3];
        shift_reg[3] <= shift_reg[2];
        shift_reg[2] <= shift_reg[1];
        shift_reg[1] <= shift_reg[0];
        shift_reg[0] <= x; // New input sample

        // Calculate the output
        accumulator = 32'b0; // Reset accumulator
        for (i = 0; i < 5; i = i + 1) begin
            accumulator = accumulator + (shift_reg[i] * coeff[i]);
        end
        y <= accumulator[15:0]; // Output is the lower 16 bits
    end
end

endmodule