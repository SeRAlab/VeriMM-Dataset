module alu (
    input [3:0] a,
    input [3:0] b,
    input sel, // 0 for addition, 1 for subtraction
    output [3:0] result,
    output carry_out);
assign {carry_out, result} = (sel == 1'b0) ? (a + b) : (a - b);
endmodule