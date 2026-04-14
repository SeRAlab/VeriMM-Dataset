module top_module(y,a,b,c,d,rsb);output y;
 input a;
 input b;
 input c;
 input d;
 input rsb;

 reg yi;

  always @(a or b or c or d or rsb) begin
   if (rsb == 0) begin
     yi <=  0;
   end 
   else begin
   if (((a&b) | (c&d))) 
    begin
      yi <=  1;
    end
    else if (((a==0) & (b==0) & (c==0) & (d==0))) 
    begin
      yi <=  0;
    end
  end

   end
  assign #1 y = yi; 
endmodule