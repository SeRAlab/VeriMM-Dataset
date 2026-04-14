module top_module( 
    input PCLK, 
input [11:0] VtcHCnt, 
input [10:0] VtcVCnt, 
input [11:0]    center_h, 
input [10:0]   center_v,  
 output reg[3:0]  weight 
);wire [11:0]diff_h; 
wire [10:0]diff_v; 
assign diff_h = (VtcHCnt > center_h)? (VtcHCnt - center_h):(center_h - VtcHCnt); 
assign diff_v = (VtcVCnt > center_v)? (VtcVCnt - center_v):(center_v - VtcVCnt); 
 
 
always@(posedge PCLK)begin 
if(diff_h <80 && diff_v<45) 
weight <= 4'b1111; 
if(diff_h >80 && diff_v>45 && diff_h <160 && diff_v<90) 
weight <= 4'b1101; 
  if(diff_h >160 && diff_v>90&&diff_h <240 && diff_v<135) 
 weight <= 4'b1001; 
   if(diff_h >240 && diff_v>135&&diff_h <320 && diff_v<180) 
weight <= 4'b0101; 
  if(diff_h >320 && diff_v>180&&diff_h <400 && diff_v<225) 
weight <= 4'b0011; 
  if(diff_h >400 && diff_v>225&&diff_h <480 && diff_v<270) 
weight <= 4'b0010; 
  if(diff_h >480 && diff_v>270&&diff_h <560 && diff_v<315) 
weight <= 4'b0010; 
 
 if(diff_h >560 && diff_v>315) 
 weight <= 4'b0001;   
end 
 
endmodule