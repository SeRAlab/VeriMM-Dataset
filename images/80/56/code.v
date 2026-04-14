module top_module(
    input [1:0] A, B,
    input EN,
    input clk,            // Added clk as an input
    output reg [15:0] Y
);reg [1:0] A_reg, B_reg;
reg EN_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    EN_reg <= EN;
end

always @(posedge clk) begin
    if (EN_reg) begin
        case ({A_reg, B_reg})
            2'b00: Y <= 16'b1111111111111110;
            2'b01: Y <= 16'b1111111111111101;
            2'b10: Y <= 16'b1111111111111011;
            2'b11: Y <= 16'b1111111111110111;
            default: Y <= 16'b1111111111111111;
        endcase
    end else begin
        Y <= 16'b1111111111111111;
    end
end

endmodule