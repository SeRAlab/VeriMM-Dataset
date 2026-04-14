module top_module(data0,data1,data2,data3,selectinput,out);input [15:0] data0,data1,data2,data3; 
 input [1:0]selectinput; 
 output reg [15:0] out; 
 always @(*) 
 begin 
 case (selectinput) 
 0: 
  out = data0; 
 1: 
  out = data1; 
 2: 
  out = data2; 
 3: 
  out = data3; 
 default: 
  out = data0; 
 endcase 
 end 
 endmodule