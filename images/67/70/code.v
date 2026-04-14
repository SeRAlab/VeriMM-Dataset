module top_module(forward,Databus,writedata,ALUresult,data);input [1:0] forward;
input [31:0] Databus;
input [31:0] writedata;
input [31:0] ALUresult;
output [31:0] data;

assign data = (forward == 2'b00) ? Databus :
              (forward == 2'b01) ? writedata :
              ALUresult;

endmodule