module fir_filter (
    input wire clk,
    input wire [15:0] x_in,
    output reg [15:0] y_out
);
    reg [15:0] coeff [0:31]; // Coefficients
    reg [15:0] x [0:31];     // Delay line
    integer i;

    initial begin
        // Initialize coefficients (example values)
        coeff[0] = 16'h0001; coeff[1] = 16'h0001; coeff[2] = 16'h0001; coeff[3] = 16'h0001;
        coeff[4] = 16'h0001; coeff[5] = 16'h0001; coeff[6] = 16'h0001; coeff[7] = 16'h0001;
        coeff[8] = 16'h0001; coeff[9] = 16'h0001; coeff[10] = 16'h0001; coeff[11] = 16'h0001;
        coeff[12] = 16'h0001; coeff[13] = 16'h0001; coeff[14] = 16'h0001; coeff[15] = 16'h0001;
        coeff[16] = 16'h0001; coeff[17] = 16'h0001; coeff[18] = 16'h0001; coeff[19] = 16'h0001;
        coeff[20] = 16'h0001; coeff[21] = 16'h0001; coeff[22] = 16'h0001; coeff[23] = 16'h0001;
        coeff[24] = 16'h0001; coeff[25] = 16'h0001; coeff[26] = 16'h0001; coeff[27] = 16'h0001;
        coeff[28] = 16'h0001; coeff[29] = 16'h0001; coeff[30] = 16'h0001; coeff[31] = 16'h0001;
    end

    always @(posedge clk) begin
        // Shift the input through the delay line
        for (i = 31; i > 0; i = i - 1) begin
            x[i] <= x[i - 1];
        end
        x[0] <= x_in;

        // Compute the output
        y_out <= 16'h0000;
        for (i = 0; i < 32; i = i + 1) begin
            y_out <= y_out + (x[i] * coeff[i]);
        end
    end
endmodule