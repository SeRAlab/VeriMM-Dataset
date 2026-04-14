module iir_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x_in, // Input signal
    output reg [15:0] y_out // Output signal
);
    // Coefficients for the 4th-order IIR filter (example values)
    parameter [15:0] b0 = 16'h0001, b1 = 16'h0002, b2 = 16'h0001, b3 = 16'h0000; // Feedforward
    parameter [15:0] a1 = 16'h0004, a2 = 16'h0003, a3 = 16'h0001; // Feedback

    reg [15:0] x [0:3]; // Input history
    reg [15:0] y [0:3]; // Output history

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize states
            x[0] <= 16'h0000;
            x[1] <= 16'h0000;
            x[2] <= 16'h0000;
            x[3] <= 16'h0000;
            y[0] <= 16'h0000;
            y[1] <= 16'h0000;
            y[2] <= 16'h0000;
            y[3] <= 16'h0000;
            y_out <= 16'h0000;
        end else begin
            // Shift input history
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            // Shift output history
            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];

            // IIR filter calculation
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] 
                      - a1 * y[1] - a2 * y[2] - a3 * y[3]) >> 4; // Right shift for scaling
            y[0] <= y_out; // Store current output
        end
    end
endmodule