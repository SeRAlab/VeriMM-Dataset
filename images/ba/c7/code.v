module top_module(MemtoReg,ALUresult,rdata,PCplus,writedata);input [1:0] MemtoReg;
input [31:0] ALUresult;
input [31:0] rdata;
input [31:0] PCplus;
output [31:0] writedata;

assign writedata = (MemtoReg == 2'b00) ? ALUresult :
                   (MemtoReg == 2'b01) ? rdata :
                   PCplus;

endmodule