module top_module(input clk,we,
output [7:0] dataout1 , dataout2,
input [3:0] readadr1,readadr2,writeadr,
input [7:0] datain);reg [7:0] registerfile[0:15];
always @(posedge clk)
begin
if(we)
registerfile[writeadr] <= datain;
registerfile[0] <= 0; 
end
assign dataout1 = registerfile[readadr1];
assign dataout2 = registerfile[readadr2];
endmodule