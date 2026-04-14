module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x, // input signal
    output reg signed [15:0] y // output signal
);
    // Define filter coefficients (example coefficients)
    parameter signed [15:0] b0 = 16'h0A00; // Example coefficient
    parameter signed [15:0] b1 = 16'h0B00; // Example coefficient
    parameter signed [15:0] b2 = 16'h0C00; // Example coefficient
    parameter signed [15:0] b3 = 16'h0D00; // Example coefficient
    parameter signed [15:0] b4 = 16'h0E00; // Example coefficient
    parameter signed [15:0] a1 = 16'hF100; // Example coefficient
    parameter signed [15:0] a2 = 16'hF200; // Example coefficient
    parameter signed [15:0] a3 = 16'hF300; // Example coefficient
    parameter signed [15:0] a4 = 16'hF400; // Example coefficient

    reg signed [15:0] x_delay [0:4]; // Delay line for input
    reg signed [15:0] y_delay [0:4]; // Delay line for output

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            x_delay[0] <= 16'h0000;
            x_delay[1] <= 16'h0000;
            x_delay[2] <= 16'h0000;
            x_delay[3] <= 16'h0000;
            x_delay[4] <= 16'h0000;
            y_delay[0] <= 16'h0000;
            y_delay[1] <= 16'h0000;
            y_delay[2] <= 16'h0000;
            y_delay[3] <= 16'h0000;
            y_delay[4] <= 16'h0000;
        end else begin
            // Shift the input and output delay lines
            x_delay[4] <= x_delay[3];
            x_delay[3] <= x_delay[2];
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x;
            
            y_delay[4] <= y_delay[3];
            y_delay[3] <= y_delay[2];
            y_delay[2] <= y_delay[1];
            y_delay[1] <= y_delay[0];
            
            // Compute the output
            y <= (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] + b3 * x_delay[3] + b4 * x_delay[4]
                  - a1 * y_delay[1] - a2 * y_delay[2] - a3 * y_delay[3] - a4 * y_delay[4]) >>> 15; // Scaling
            y_delay[0] <= y;
        end
    end
endmodule