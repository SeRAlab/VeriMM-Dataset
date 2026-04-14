module top_module(q, q_calc, a, b, c);output q;
   output q_calc;
   input  a;
   input  b;
   input  c;

   reg	  q;
   reg    q_calc;

   always @(a or b or c) begin
      if(a===b && b===c)
	 q <= 1;
      else
	 q <= 0;
   end 

   
   
   
   always @(a or b or c)
     begin
       if( a===b)
        begin
          if(b === c)
            q_calc = 1'b1;
          else
            q_calc = 1'b0;
        end
      else
          q_calc = 1'b0;
     end

endmodule