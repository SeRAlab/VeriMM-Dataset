module top_module(
    input [31:0] ADD4,
    input [31:0] NPC,
    input [31:0] jrPC,
    input [2:0] PC_sel,
    input CMP_out,
    output [31:0] nextPC
    );assign nextPC = (PC_sel == 3)?jrPC:
						 ((PC_sel == 2)||((PC_sel == 1)&&(CMP_out == 1)))?NPC:ADD4;endmodule