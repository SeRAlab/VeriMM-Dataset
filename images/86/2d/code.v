module top_module(
   
   q,
   
   en, i, rstn
   );input en;
   input i;
   input rstn;
   output q;
   reg    q;

   always @* begin
      if(rstn == 1'b0)
        q <= 0;
      else
        if(en)
          q <= i;

   end
endmodule