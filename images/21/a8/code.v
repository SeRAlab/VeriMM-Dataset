module fir_filter (
    input [15:0] x, // 16-bit input
    output reg [15:0] y // 16-bit output
);
    reg [15:0] coeff [0:15]; // Coefficients
    reg [31:0] acc; // Accumulator
    integer i;

    initial begin
        // Initialize coefficients (example coefficients)
        coeff[0] = 16'h0001;
        coeff[1] = 16'h0002;
        coeff[2] = 16'h0003;
        coeff[3] = 16'h0001;
        coeff[4] = 16'h0002;
        coeff[5] = 16'h0003;
        coeff[6] = 16'h0001;
        coeff[7] = 16'h0002;
        coeff[8] = 16'h0003;
        coeff[9] = 16'h0001;
        coeff[10] = 16'h0002;
        coeff[11] = 16'h0003;
        coeff[12] = 16'h0001;
        coeff[13] = 16'h0002;
        coeff[14] = 16'h0003;
        coeff[15] = 16'h0001;
    end

    always @(*) begin
        acc = 0; // Clear accumulator
        for (i = 0; i < 16; i = i + 1) begin
            acc = acc + (coeff[i] * x); // Multiply and accumulate
        end
        y = acc[15:0]; // Output only the lower 16 bits
    end
endmodule