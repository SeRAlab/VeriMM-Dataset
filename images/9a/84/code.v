module top_module(q,qbar,data,set,reset,clk);output q,qbar;
  input data,set,reset,clk;
  reg q;
  assign qbar = -q;

  always@(negedge reset or negedge set or posedge clk)begin
  if(reset ==0) q=0;
  else if(set==0) q=1;
  else q= data;
  end
  endmodule