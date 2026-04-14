module iir_filter (
    input clk,
    input rst,
    input [15:0] x_in, // Input signal
    output reg [15:0] y_out // Output signal
);
    reg [15:0] x_reg [0:2]; // Input shift register
    reg [15:0] y_reg [0:1]; // Output shift register
    parameter b0 = 16'h0A0A; // Coefficient for x[n]
    parameter b1 = 16'h0B0B; // Coefficient for x[n-1]
    parameter a1 = 16'h0C0C; // Coefficient for y[n-1]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_reg[0] <= 16'b0;
            x_reg[1] <= 16'b0;
            x_reg[2] <= 16'b0;
            y_reg[0] <= 16'b0;
            y_reg[1] <= 16'b0;
            y_out <= 16'b0;
        end else begin
            // Shift input values
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x_in;

            // Calculate the output
            y_out <= (b0 * x_reg[0] + b1 * x_reg[1] - a1 * y_reg[0]) >> 8;

            // Shift output values
            y_reg[1] <= y_reg[0];
            y_reg[0] <= y_out;
        end
    end
endmodule