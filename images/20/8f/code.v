module fir_filter (
    input signed [15:0] x_in,
    input clk,
    input rst,
    output reg signed [15:0] y_out
);
    parameter N = 32;
    reg signed [15:0] coeffs [0:N-1];
    reg signed [15:0] delay_line [0:N-1];
    integer i;

    initial begin
        // Initialize filter coefficients (example coefficients)
        coeffs[0]  = 16'h0001; coeffs[1]  = 16'h0002; coeffs[2]  = 16'h0003; // and so on...
        coeffs[3]  = 16'h0004; coeffs[4]  = 16'h0005; coeffs[5]  = 16'h0006; 
        coeffs[6]  = 16'h0007; coeffs[7]  = 16'h0008; coeffs[8]  = 16'h0009; 
        // Initialize remaining coefficients...
        coeffs[31] = 16'h0010; // Last coefficient
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                delay_line[i] <= 16'h0000;
            end
            y_out <= 16'h0000;
        end else begin
            // Shift the delay line
            for (i = N-1; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            delay_line[0] <= x_in;

            // Compute the output
            y_out <= 16'h0000; // Clear output before computation
            for (i = 0; i < N; i = i + 1) begin
                y_out <= y_out + (delay_line[i] * coeffs[i]);
            end
        end
    end
endmodule