module top_module( din ,clk ,reset ,dout );output dout ;
reg dout ;

input din ;
wire din ;
input clk ;
wire clk ;
input reset ;
wire reset ;    

reg [3:0]s;

always @ (posedge (clk)) begin 
 if (reset)
  dout <= 0;
 else begin
  s[0] <= din ;
  s[1] <= s[0] ;
  s[2] <= s[1] ;
  s[3] <= s[2]; 
  dout <= s[3];
 end
end

endmodule