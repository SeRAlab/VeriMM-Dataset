module FIR_Filter (
    input [3:0] x,
    input clk,
    output reg [7:0] y
);
    reg [3:0] x_reg [0:3]; // Shift registers for input samples
    integer i;
    
    always @(posedge clk) begin
        // Shift input samples
        x_reg[3] <= x_reg[2];
        x_reg[2] <= x_reg[1];
        x_reg[1] <= x_reg[0];
        x_reg[0] <= x;
    end

    always @(*) begin
        // Calculate output y as the sum of products with fixed coefficients
        y = 0;
        for (i = 0; i < 4; i = i + 1) begin
            case (i)
                0: y = y + (x_reg[i] * 1);
                1: y = y + (x_reg[i] * 2);
                2: y = y + (x_reg[i] * 3);
                3: y = y + (x_reg[i] * 4);
            endcase
        end
    end
endmodule