module fir_filter (
    input [15:0] x, // Input signal
    output reg [31:0] y // Filtered output
);
    reg [15:0] coeff [0:15]; // Coefficients
    reg [31:0] temp; // Temporary variable for calculation
    integer i;

    initial begin
        // Initialize coefficients (example values)
        coeff[0] = 16'h0001;
        coeff[1] = 16'h0002;
        coeff[2] = 16'h0003;
        coeff[3] = 16'h0004;
        coeff[4] = 16'h0005;
        coeff[5] = 16'h0006;
        coeff[6] = 16'h0007;
        coeff[7] = 16'h0008;
        coeff[8] = 16'h0009;
        coeff[9] = 16'h000A;
        coeff[10] = 16'h000B;
        coeff[11] = 16'h000C;
        coeff[12] = 16'h000D;
        coeff[13] = 16'h000E;
        coeff[14] = 16'h000F;
        coeff[15] = 16'h0010;
    end

    always @(*) begin
        temp = 32'h00000000; // Clear temp
        for (i = 0; i < 16; i = i + 1) begin
            temp = temp + (coeff[i] * x); // Multiply and accumulate
        end
        y = temp; // Assign result to output
    end
endmodule