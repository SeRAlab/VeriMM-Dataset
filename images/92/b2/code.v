module top_module(
    input clk,
    input [4:0]in_EX,
    input [2:0]in_M,
    input [1:0]in_WB,
    input [31:0]in_add,
    input [31:0]in_Dato1,
    input [31:0]in_Dato2,
    input [31:0]in_Extend,
    input [4:0]in_b20_16,
    input [4:0]in_b15_11,
    output reg[31:0]ou_add,
    output reg[31:0]ou_Dato_1,
    output reg[31:0]ou_Dato_2,
    output reg[31:0]ou_Extend,
    output reg[4:0]ou_b20_16,
    output reg[4:0]ou_b15_11,
    output reg[4:0]ou_EX,
    output reg[2:0]ou_M,
    output reg[1:0]ou_WB
);always @(posedge clk) begin
    ou_add = in_add;
    ou_Dato_1 = in_Dato1;
    ou_Dato_2 = in_Dato2;
    ou_Extend = in_Extend;
    ou_b20_16 = in_b20_16;
    ou_b15_11 = in_b15_11;
    ou_EX = in_EX;
    ou_M = in_M;
    ou_WB = in_WB;
end

endmodule