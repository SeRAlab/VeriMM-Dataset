module top_module(datain, dataout, clk, clr, WE);input [31:0] datain;
    output [31:0] dataout;
    input clk, clr, WE;

    reg [31:0] register;

always @(posedge clk or posedge clr)
begin
  if(clr)
    register = 0;  
  else
    if(WE == 1)
    register =  datain;
end    
  assign dataout = register;

endmodule