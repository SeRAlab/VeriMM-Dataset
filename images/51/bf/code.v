module top_module(datain, pcin, pcout);input [31:0] datain, pcin;
output [31:0] pcout;
reg [31:0] pcout;

always @ (datain or pcin)
begin
  pcout = {pcin[31:28],datain[27:0]};
end

endmodule