module adaptive_lms_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x,        // Input signal
    input wire [15:0] d,        // Desired output signal
    output reg [15:0] y,        // Actual output signal
    output reg [15:0] w0, w1, w2 // Coefficients
);
    parameter N = 3;            // Number of taps
    parameter mu = 16'h0001;    // Step size (learning rate)
    
    reg [15:0] x_reg [0:N-1];   // Delay line
    reg [15:0] error;           // Error signal

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w0 <= 16'h0000;
            w1 <= 16'h0000;
            w2 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            // Shift inputs into the delay line
            x_reg[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_reg[i] <= x_reg[i-1];
            end
            
            // Calculate output
            y <= (w0 * x_reg[0]) + (w1 * x_reg[1]) + (w2 * x_reg[2]);

            // Calculate error
            error <= d - y;

            // Update weights
            w0 <= w0 + (mu * error * x_reg[0]);
            w1 <= w1 + (mu * error * x_reg[1]);
            w2 <= w2 + (mu * error * x_reg[2]);
        end
    end
endmodule