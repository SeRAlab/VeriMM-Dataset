module FIR_Filter (
    input wire clk,
    input wire [15:0] x,           // 16-bit input signal
    output reg [15:0] y           // 16-bit output signal
);
    reg [15:0] coeffs [0:15];     // Filter coefficients
    reg [15:0] delay_line [0:15];  // Delay line for input samples
    integer i;

    initial begin
        // Define coefficients (example values)
        coeffs[0] = 16'd1;
        coeffs[1] = 16'd2;
        coeffs[2] = 16'd3;
        coeffs[3] = 16'd4;
        coeffs[4] = 16'd5;
        coeffs[5] = 16'd6;
        coeffs[6] = 16'd7;
        coeffs[7] = 16'd8;
        coeffs[8] = 16'd9;
        coeffs[9] = 16'd10;
        coeffs[10] = 16'd11;
        coeffs[11] = 16'd12;
        coeffs[12] = 16'd13;
        coeffs[13] = 16'd14;
        coeffs[14] = 16'd15;
        coeffs[15] = 16'd16;
    end

    always @(posedge clk) begin
        // Shift the delay line
        for (i = 15; i > 0; i = i - 1) begin
            delay_line[i] <= delay_line[i-1];
        end
        delay_line[0] <= x;

        // Compute the FIR output
        y <= 16'd0;
        for (i = 0; i < 16; i = i + 1) begin
            y <= y + (delay_line[i] * coeffs[i]);
        end
    end
endmodule