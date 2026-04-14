module top_module(
               
               topsig,
               
               clk
               );input  clk;
   output topsig;
   
   
          
   reg    topsig;
`define TOPSIG  {topsig}
   
   always @ (posedge clk) begin
      `TOPSIG <= #0 1'b1;
   end
   
   task direct_write;
      input val;
      begin
         `TOPSIG = val;
      end
   endtask
endmodule