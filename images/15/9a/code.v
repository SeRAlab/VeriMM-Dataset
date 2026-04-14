module echo_cancellation(
    input wire clk,
    input wire reset,
    input wire [15:0] input_signal,
    input wire [15:0] reference_signal,
    output reg [15:0] output_signal
);
    reg [15:0] delay_line [0:4]; // 5 taps for the delay line
    reg [15:0] coefficients [0:4]; // Coefficients for adaptive filtering
    reg [15:0] error_signal;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 5; i = i + 1) begin
                delay_line[i] <= 16'b0;
                coefficients[i] <= 16'b1; // Initialize coefficients
            end
            output_signal <= 16'b0;
        end else begin
            // Shift the delay line
            for (i = 4; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            delay_line[0] <= input_signal;

            // Calculate the output signal
            output_signal <= 16'b0;
            for (i = 0; i < 5; i = i + 1) begin
                output_signal <= output_signal + (delay_line[i] * coefficients[i]);
            end

            // Calculate the error signal
            error_signal <= reference_signal - output_signal;

            // Update coefficients (simple gradient descent)
            for (i = 0; i < 5; i = i + 1) begin
                coefficients[i] <= coefficients[i] + (error_signal * delay_line[i]) >> 8; // Adjusting step size
            end
        end
    end
endmodule