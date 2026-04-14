module top_module(
input clk,
input rstn,
input load, 
input dir,
input [7:0] LD,
output cout
);reg [7:0] mem;

assign cout = dir?mem[0]:mem[7] ;


always @(posedge clk or negedge rstn)
begin
 if(!rstn)
  mem <= 8'h00;
 else begin
  if(load) 
   mem <= LD ;
  else mem <= mem ;
  case(dir)
   0 : mem <= mem<<1 ;
   1 : mem <= mem>>1 ;
  endcase
 end
end

endmodule