module top_module(
    input [3:0] A,
    input clk,         // Added clk input
    output [15:0] Y
);reg [15:0] Y_reg;
reg [3:0] A_reg;

always @(posedge clk) begin
    A_reg <= A;
    Y_reg <= 16'b0;
    case (A_reg)
        4'b0000: Y_reg[15] <= 1'b1; // Changed from 0 to 1 to properly output high for decoded values
        4'b0001: Y_reg[14] <= 1'b1;
        4'b0010: Y_reg[13] <= 1'b1;
        4'b0011: Y_reg[12] <= 1'b1;
        4'b0100: Y_reg[11] <= 1'b1;
        4'b0101: Y_reg[10] <= 1'b1;
        4'b0110: Y_reg[9] <= 1'b1;
        4'b0111: Y_reg[8] <= 1'b1;
        4'b1000: Y_reg[7] <= 1'b1;
        4'b1001: Y_reg[6] <= 1'b1;
        4'b1010: Y_reg[5] <= 1'b1;
        4'b1011: Y_reg[4] <= 1'b1;
        4'b1100: Y_reg[3] <= 1'b1;
        4'b1101: Y_reg[2] <= 1'b1;
        4'b1110: Y_reg[1] <= 1'b1;
        4'b1111: Y_reg[0] <= 1'b1;
        default: Y_reg <= 16'b0;
    endcase
end

assign Y = Y_reg;

endmodule