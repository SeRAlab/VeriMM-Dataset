module IIR_Filter (
    input clk,
    input rst,
    input [11:0] x, // input sample
    output reg [11:0] y // output sample
);
    parameter [11:0] B0 = 12'd1, B1 = 12'd2, B2 = 12'd3, B3 = 12'd4; // feedforward coefficients
    parameter [11:0] A1 = 12'd5, A2 = 12'd6, A3 = 12'd7; // feedback coefficients

    reg [11:0] x_reg[0:2]; // Previous input samples
    reg [11:0] y_reg[0:3]; // Previous output samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 12'd0;
            x_reg[0] <= 12'd0;
            x_reg[1] <= 12'd0;
            x_reg[2] <= 12'd0;
            y_reg[0] <= 12'd0;
            y_reg[1] <= 12'd0;
            y_reg[2] <= 12'd0;
            y_reg[3] <= 12'd0;
        end else begin
            // Shift previous samples
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;
            
            y <= B0 * x_reg[0] + B1 * x_reg[1] + B2 * x_reg[2] 
                - A1 * y_reg[1] - A2 * y_reg[2] - A3 * y_reg[3];

            // Shift previous outputs
            y_reg[3] <= y_reg[2];
            y_reg[2] <= y_reg[1];
            y_reg[1] <= y_reg[0];
            y_reg[0] <= y;
        end
    end
endmodule