module top_module(cx0, cx1, bm0, bm1, bm2, bm3, bm4, bm5, bm6, bm7);output [1:0] bm0, bm1, bm2, bm3, bm4, bm5, bm6, bm7; 
  input cx0, cx1; 
  reg [1:0] bm0, bm1, bm2, bm3, bm4, bm5, bm6, bm7; 
  always@ (cx0 or cx1) 
  begin 
  if (cx0==0 && cx1==0) 
  begin 
  bm0 <= 2'd0; 
  bm1 <= 2'd2; 
  bm2 <= 2'd2; 
  bm3 <= 2'd0; 
  bm4 <= 2'd1; 
  bm5 <= 2'd1; 
  bm6 <= 2'd1; 
  bm7 <= 2'd1; 
  end 
  else if (cx0==0 && cx1==1) 
  begin 
  bm0 <= 2'd1; 
  bm1 <= 2'd1; 
  bm2 <= 2'd1; 
  bm3 <= 2'd1; 
  bm4 <= 2'd2; 
  bm5 <= 2'd0; 
  bm6 <= 2'd0; 
  bm7 <= 2'd2; 
  end 
  else if (cx0==1 && cx1==0) 
  begin 
  bm0 <= 2'd1; 
  bm1 <= 2'd1; 
  bm2 <= 2'd1; 
  bm3 <= 2'd1; 
  bm4 <= 2'd0; 
  bm5 <= 2'd2; 
  bm6 <= 2'd2; 
  bm7 <= 2'd0; 
  end 
  else 
  begin 
  bm0 <= 2'd2; 
  bm1 <= 2'd0; 
  bm2 <= 2'd0; 
  bm3 <= 2'd2; 
  bm4 <= 2'd1; 
  bm5 <= 2'd1; 
  bm6 <= 2'd1; 
  bm7 <= 2'd1; 
  end 
  end 
 endmodule