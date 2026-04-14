module fir_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x,           // Input signal
    output reg [15:0] y            // Output signal
);

    reg [15:0] coeff [0:7];        // Coefficients of the FIR filter
    reg [15:0] delay_line [0:7];   // Delay line for the input samples
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
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                delay_line[i] <= 16'h0000;
            end
            y <= 16'h0000;
        end else begin
            // Shift the delay line
            for (i = 7; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            delay_line[0] <= x;

            // Calculate the output
            y <= 16'h0000; // Reset output
            for (i = 0; i < 8; i = i + 1) begin
                y <= y + (delay_line[i] * coeff[i]);
            end
        end
    end
endmodule