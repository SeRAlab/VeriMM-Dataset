module fir_filter (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out
);
    parameter N = 32; // Number of taps
    reg signed [15:0] x [0:N-1]; // Input sample array
    reg signed [15:0] coeff [0:N-1]; // Coefficients
    integer i;

    // Initialize coefficients (example coefficients)
    initial begin
        coeff[0] = 16'd1;   coeff[1] = 16'd2;   coeff[2] = 16'd3;   coeff[3] = 16'd4;
        coeff[4] = 16'd5;   coeff[5] = 16'd6;   coeff[6] = 16'd7;   coeff[7] = 16'd8;
        coeff[8] = 16'd9;   coeff[9] = 16'd10;  coeff[10] = 16'd11; coeff[11] = 16'd12;
        coeff[12] = 16'd13; coeff[13] = 16'd14; coeff[14] = 16'd15; coeff[15] = 16'd16;
        coeff[16] = 16'd17; coeff[17] = 16'd18; coeff[18] = 16'd19; coeff[19] = 16'd20;
        coeff[20] = 16'd21; coeff[21] = 16'd22; coeff[22] = 16'd23; coeff[23] = 16'd24;
        coeff[24] = 16'd25; coeff[25] = 16'd26; coeff[26] = 16'd27; coeff[27] = 16'd28;
        coeff[28] = 16'd29; coeff[29] = 16'd30; coeff[30] = 16'd31; coeff[31] = 16'd32;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 32'd0;
            for (i = 0; i < N; i = i + 1)
                x[i] <= 16'd0;
        end else begin
            // Shift the input samples
            for (i = N-1; i > 0; i = i - 1) begin
                x[i] <= x[i-1];
            end
            x[0] <= x_in;

            // Compute the output
            y_out <= 32'd0; // Reset output
            for (i = 0; i < N; i = i + 1) begin
                y_out <= y_out + (x[i] * coeff[i]);
            end
        end
    end
endmodule