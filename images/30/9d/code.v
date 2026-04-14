module adaptive_lms_filter #(parameter N = 4)(
    input clk,
    input reset,
    input signed [15:0] x, // input signal
    input signed [15:0] d, // desired signal
    output reg signed [15:0] y // output signal
);
    reg signed [15:0] w [0:N-1]; // filter coefficients
    reg signed [15:0] e; // error signal
    reg signed [15:0] mu = 16'd1; // step size
    reg signed [15:0] x_delayed [0:N-1]; // delayed input signals

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'd0; // initialize weights
                x_delayed[i] <= 16'd0; // initialize delays
            end
            y <= 16'd0;
        end else begin
            // Shift input samples
            x_delayed[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_delayed[i] <= x_delayed[i-1];
            end

            // Calculate output
            y <= 16'd0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + w[i] * x_delayed[i];
            end

            // Calculate error
            e <= d - y;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * e * x_delayed[i]) >>> 15; // scale down to fit
            end
        end
    end
endmodule