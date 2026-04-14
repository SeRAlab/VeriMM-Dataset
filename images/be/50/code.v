module top_module(data0,data1,selectinput,out);input [2:0] data0,data1; 
 input selectinput; 
 output reg [2:0] out; 
 always @(*) 
 begin 
 case (selectinput) 
 0: 
  out = data0; 
 1: 
  out = data1; 
 default: 
  out = data0; 
 endcase 
 end 
 endmodule