module top_module(y,a,b,c,rsb);output y;
 input a;
 input b;
 input c;
 input rsb;

 reg yi;

  always @(a or b or c or rsb) begin
   if (rsb == 0)begin
      yi <=  0;
   end else   if (((a) & (b) & (c))) 
    begin
      yi <=  1;
    end
    else if (((a==0) & (b==0) & (c==0))) 
    begin
      yi <=  0;
    end
    else
    begin
      yi <= 0;
    end
   end
  assign #1 y = yi; 
endmodule