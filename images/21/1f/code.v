module lms_filter (
    input clk,
    input reset,
    input signed [15:0] x,  // input signal
    input signed [15:0] d,  // desired signal
    output signed [15:0] y   // output signal
);

parameter N = 5; // number of filter taps
parameter mu = 16'h0001; // step size (can be tuned)

reg signed [15:0] w [0:N-1]; // filter coefficients
reg signed [15:0] x_delay [0:N-1]; // delayed input samples
reg signed [15:0] y_accum; // accumulator for output
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize weights to zero
        for (i=0; i<N; i=i+1) begin
            w[i] <= 16'h0000;
        end
        y_accum <= 16'h0000;
    end else begin
        // Shift input samples
        for (i=N-1; i>0; i=i-1) begin
            x_delay[i] <= x_delay[i-1];
        end
        x_delay[0] <= x;

        // Calculate output
        y_accum <= 16'h0000;
        for (i=0; i<N; i=i+1) begin
            y_accum <= y_accum + (w[i] * x_delay[i]);
        end

        // Update coefficients
        for (i=0; i<N; i=i+1) begin
            w[i] <= w[i] + (mu * (d - y_accum) * x_delay[i]);
        end
    end
end

assign y = y_accum;

endmodule