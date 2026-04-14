module top_module(y,a,b,c);output y;
 input a;
 input b;
 input c;

 reg yi;

  always @(a or b or c) begin
   if (((a) | (b & c))) 
    begin
      yi <=  1;
    end
    else if (((a==0) & (b==0) & (c==0))) 
    begin
      yi <=  0;
    end
   end
  assign #1 y = yi; 
endmodule