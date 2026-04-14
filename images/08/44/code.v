module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    reg signed [15:0] x_reg [0:2]; // Previous input samples
    reg signed [15:0] y_reg [0:2]; // Previous output samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_reg[0] <= 0;
            x_reg[1] <= 0;
            x_reg[2] <= 0;
            y_reg[0] <= 0;
            y_reg[1] <= 0;
            y_reg[2] <= 0;
            y <= 0;
        end else begin
            // Shift previous samples
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;

            y_reg[2] <= y_reg[1];
            y_reg[1] <= y_reg[0];

            // IIR filter equation
            y_reg[0] <= (1 * x_reg[0] + 0.5 * x_reg[1] + 0.25 * x_reg[2]) 
                        - (0.5 * y_reg[1] + 0.25 * y_reg[2]);
            y <= y_reg[0];
        end
    end
endmodule