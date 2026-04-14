module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    parameter signed [15:0] b0 = 16'h1F00; // Feedforward coefficients
    parameter signed [15:0] b1 = 16'h1F00;
    parameter signed [15:0] b2 = 16'h1F00;
    parameter signed [15:0] b3 = 16'h1F00;
    parameter signed [15:0] b4 = 16'h1F00;
    
    parameter signed [15:0] a1 = 16'hF800; // Feedback coefficients
    parameter signed [15:0] a2 = 16'hF800;
    parameter signed [15:0] a3 = 16'hF800;
    parameter signed [15:0] a4 = 16'hF800;

    reg signed [15:0] x [0:4]; // Input samples
    reg signed [15:0] y [0:4]; // Output samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'h0000;
            x[0] <= 16'h0000;
            x[1] <= 16'h0000;
            x[2] <= 16'h0000;
            x[3] <= 16'h0000;
            x[4] <= 16'h0000;
            y[0] <= 16'h0000;
            y[1] <= 16'h0000;
            y[2] <= 16'h0000;
            y[3] <= 16'h0000;
            y[4] <= 16'h0000;
        end else begin
            // Shift samples
            x[4] <= x[3];
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;
            
            // Calculate the output
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4]
                      - a1 * y[1] - a2 * y[2] - a3 * y[3] - a4 * y[4]) >>> 15;
            
            // Shift output samples
            y[4] <= y[3];
            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];
            y[0] <= y_out;
        end
    end
endmodule