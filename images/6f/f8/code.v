module top_module(
   input ai, bi, ci,
   output reg ao, bo, co
);always@*
   begin
      ao=ai;
      bo=bi;
      co=ci;
      {co,co,bo,ao} = {ai,bi,ai,ci}; 
   end

endmodule