module adaptive_lms #(parameter N = 5, parameter L = 16) (
    input clk,
    input reset,
    input signed [15:0] x, // input signal
    input signed [15:0] d, // desired output
    output signed [15:0] y, // actual output
    output signed [15:0] error // error signal
);
    reg signed [15:0] w [0:N-1]; // coefficients
    reg signed [15:0] x_delay [0:N-1]; // delayed input samples
    reg signed [15:0] y_reg; // output
    reg signed [15:0] error_reg;
    integer i;

    initial begin
        for (i = 0; i < N; i = i + 1) begin
            w[i] = 0; // Initialize weights
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 0;
            end
            y_reg <= 0;
            error_reg <= 0;
        end else begin
            // Shift input samples
            x_delay[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_delay[i] <= x_delay[i-1];
            end

            // Calculate output
            y_reg <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y_reg <= y_reg + (w[i] * x_delay[i]);
            end

            // Calculate error
            error_reg <= d - y_reg;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (error_reg * x_delay[i]) >> 4; // Step size
            end
        end
    end

    assign y = y_reg;
    assign error = error_reg;
endmodule