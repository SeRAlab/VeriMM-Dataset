module top_module(output [31:0] regData,input [31:0] q1,input [31:0] q2, input [31:0] q3, input [31:0] q4,input [1:0] reg_no);assign regData = reg_no==2'b00 ? q1:
                 reg_no==2'b01 ? q2:
                 reg_no==2'b10 ? q3:
                 q4;endmodule