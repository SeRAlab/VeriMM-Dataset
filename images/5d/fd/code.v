module down_counter_2bit (count, clk, reset);
   input clk, reset;
   output [1:0] count;
   
   reg [1:0] count;
   
   always @(posedge clk) begin
      if (reset)
         count <= 2'b11;
      else
         count <= count - 1;
   end //End of always block
    
endmodule