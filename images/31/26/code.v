module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // input sample
    output reg signed [15:0] y // output sample
);
    // Filter coefficients (example values)
    parameter signed [15:0] b0 = 16'h0A00; // Example coefficient
    parameter signed [15:0] b1 = 16'h0A00;
    parameter signed [15:0] b2 = 16'h0A00;
    parameter signed [15:0] b3 = 16'h0A00;
    parameter signed [15:0] b4 = 16'h0A00;
    parameter signed [15:0] a1 = 16'hF800; // Example coefficient
    parameter signed [15:0] a2 = 16'hF800;
    parameter signed [15:0] a3 = 16'hF800;
    parameter signed [15:0] a4 = 16'hF800;

    reg signed [15:0] x_reg [0:4]; // Input samples
    reg signed [15:0] y_reg [0:3]; // Output samples

    // Initialize the states
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            for (i = 0; i < 5; i = i + 1) begin
                x_reg[i] <= 16'h0000;
            end
            for (i = 0; i < 4; i = i + 1) begin
                y_reg[i] <= 16'h0000;
            end
        end else begin
            // Shift input samples
            x_reg[4] <= x;
            for (i = 4; i > 0; i = i - 1) begin
                x_reg[i-1] <= x_reg[i];
            end

            // Calculate output sample
            y <= b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2] + b3 * x_reg[3] + b4 * x_reg[4] 
                 - a1 * y_reg[0] - a2 * y_reg[1] - a3 * y_reg[2] - a4 * y_reg[3];

            // Shift output samples
            for (i = 3; i > 0; i = i - 1) begin
                y_reg[i] <= y_reg[i-1];
            end
            y_reg[0] <= y;
        end
    end
endmodule