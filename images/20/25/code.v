module EchoCancellation (
    input wire clk,
    input wire reset,
    input wire signed [15:0] audio_in,
    input wire signed [15:0] echo_ref,
    output reg signed [15:0] audio_out
);
    reg signed [15:0] delay_line [0:4]; // 5 tap filter
    reg signed [15:0] coeff [0:4]; // Coefficients for each tap
    integer i;

    // Initialize coefficients
    initial begin
        coeff[0] = 16'h0001; // Example coefficient values
        coeff[1] = 16'h0001;
        coeff[2] = 16'h0001;
        coeff[3] = 16'h0001;
        coeff[4] = 16'h0001;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 16'h0000;
            // Reset delay line
            for (i = 0; i < 5; i = i + 1) begin
                delay_line[i] <= 16'h0000;
            end
        end else begin
            // Shift delay line
            for (i = 4; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            delay_line[0] <= echo_ref;

            // Calculate output
            audio_out <= audio_in - (coeff[0] * delay_line[0] + coeff[1] * delay_line[1] +
                                      coeff[2] * delay_line[2] + coeff[3] * delay_line[3] +
                                      coeff[4] * delay_line[4]);
        end
    end
endmodule