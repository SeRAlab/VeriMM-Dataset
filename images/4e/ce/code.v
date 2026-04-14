module top_module(product,x,y);input  [15:0] x,y; 
output [31:0] product; 
 
wire [31:0] prod1,prod2,prod3,prod4; 
reg [1:0]path; 
  
assign prod1=x[14:0]*y[14:0]; 
assign prod2={{2{x[15]}},{{15{x[15]}}&(~y[14:0])},{15{1'b0}}}; 
assign prod3={{2{y[15]}},{{15{y[15]}}&(~x[14:0])},{15{1'b0}}}; 
assign prod4={1'b0,{x[15]&y[15]},{13{1'b0}},path,{15{1'b0}}}; 
assign product=(prod1+prod2)+(prod3+prod4); 
 
always@(x[15] or y[15])begin 
case({x[15],y[15]}) 
2'b00:path=2'b00; 
2'b01:path=2'b01; 
2'b10:path=2'b01; 
2'b11:path=2'b10; 
endcase 
end 
 
endmodule