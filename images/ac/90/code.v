module top_module(
    input clk,
    input [1:0] alu_op,
    input [5:0] func_op,
    output reg [3:0] alu_control_sig
    );always@(posedge clk)
begin


if (alu_op == 2'b00)
    alu_control_sig = 4'b0010;


if (alu_op == 2'b01)
    alu_control_sig = 4'b0110;


if (alu_op == 2'b10 && func_op[3:0] == 4'b0000)
    alu_control_sig = 4'b0010;


if (alu_op[1] == 1 && func_op[3:0] == 4'b0010)
    alu_control_sig = 4'b0110;


if (alu_op == 2'b10 && func_op[3:0] == 4'b0100)
    alu_control_sig = 4'b0000;


if (alu_op == 2'b10 && func_op[3:0] == 4'b0101)
    alu_control_sig = 4'b0001;


if (alu_op[1] == 1 && func_op[3:0] == 4'b1010)
    alu_control_sig = 4'b0111;


end    
endmodule