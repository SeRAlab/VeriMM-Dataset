module adaptive_lms_filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    input signed [15:0] d, // Desired signal
    output signed [15:0] y, // Output signal
    output signed [15:0] error // Error signal
);
    parameter N = 4; // Number of taps
    parameter mu = 16'h0001; // Step size for adaptation

    reg signed [15:0] w [0:N-1]; // Coefficients
    reg signed [15:0] x_delayed [0:N-1]; // Delayed input signals
    reg signed [15:0] y_int; // Internal output signal
    reg signed [15:0] error_int; // Internal error signal

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 0;
                x_delayed[i] <= 0;
            end
            y_int <= 0;
            error_int <= 0;
        end else begin
            // Shift input samples
            for (i = N-1; i > 0; i = i - 1) begin
                x_delayed[i] <= x_delayed[i-1];
            end
            x_delayed[0] <= x;

            // Compute output
            y_int <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y_int <= y_int + (w[i] * x_delayed[i]);
            end

            // Compute error
            error_int <= d - y_int;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * error_int * x_delayed[i]);
            end
        end
    end

    assign y = y_int;
    assign error = error_int;

endmodule