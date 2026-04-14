module top_module(forward,databus,ALUresult,Memaddr,writedata,dataout);input [1:0] forward;
input [31:0] databus;
input [31:0] ALUresult;
input [31:0] Memaddr;
input [31:0] writedata;
output [31:0] dataout;

assign dataout = (forward == 2'b00) ? databus :
                 (forward == 2'b01) ? ALUresult :
                 (forward == 2'b10) ? Memaddr :
                 writedata;

endmodule