module top_module(datain, dataout);input [31:0] datain;
output [31:0] dataout;
reg [31:0] dataout;

always @ (datain)
begin
  dataout = datain * 4;
end
endmodule