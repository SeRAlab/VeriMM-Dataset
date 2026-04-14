module top_module(y,a,b);output y;
 input a;
 input b;

 reg yi;

  always @(a or b) begin
   if (((a) & (b))) 
    begin
      yi <=  1;
    end
    else if (((a==0) & (b==0))) 
    begin
      yi <=  0;
    end
   end
  assign #1 y = yi; 
endmodule