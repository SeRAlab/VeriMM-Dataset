module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg valid
);reg [15:0] result;
reg [7:0] a_reg;
reg [7:0] b_reg;
reg [1:0] op_reg;
reg valid_reg;

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        a_reg <= 0;
        b_reg <= 0;
        op_reg <= 0;
        valid_reg <= 0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        op_reg <= op;
        case (op)
            2'b00: result <= a_reg + b_reg;
            2'b01: result <= a_reg - b_reg;
            2'b10: result <= a_reg * b_reg;
            2'b11: result <= a_reg / b_reg;
        endcase
        out <= result[7:0];
        valid_reg <= 1;
    end
end

always @(negedge clk) begin
    valid <= valid_reg;
end

endmodule