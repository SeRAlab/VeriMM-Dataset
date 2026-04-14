module echo_cancellation (
    input clk,
    input reset,
    input signed [15:0] input_signal,
    input signed [15:0] reference_signal,
    output reg signed [15:0] output_signal
);
    parameter N = 5; // number of filter taps
    parameter signed [15:0] mu = 16'h0001; // step size for LMS
    reg signed [15:0] w [0:N-1]; // filter coefficients
    reg signed [15:0] y; // filtered output
    reg signed [15:0] error; // error signal

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000; // initialize weights to zero
            end
            output_signal <= 16'h0000;
        end else begin
            // Calculate the filter output
            y = 0;
            for (i = 0; i < N; i = i + 1) begin
                y = y + (w[i] * reference_signal); // accumulate filter output
            end
            
            // Calculate the error
            error = input_signal - y;
            output_signal = error; // output is error signal
            
            // Update filter coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] = w[i] + (mu * error * reference_signal); // LMS update
            end
        end
    end
endmodule