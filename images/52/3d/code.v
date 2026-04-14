module top_module(regmel_out,regmel_in,regmel_addr,regmel_wren,clk,reset);output [44:0]regmel_out;

input [4:0]regmel_addr;
input [44:0]regmel_in;
input regmel_wren;
input clk,reset;

parameter WIDTH=31;
integer i;

reg [44:0] registers[WIDTH:0];


assign regmel_out = registers[regmel_addr];

always@(posedge clk or negedge reset)
begin 
  if(reset==0)
    for(i=0;i<WIDTH;i=i+1) 
      begin
        registers[i]<=0;
      end
  else
    if(regmel_wren)
      registers[regmel_addr]<=regmel_in;
end
endmodule