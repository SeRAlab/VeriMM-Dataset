module counter_8bit (count, clk, reset, en);
   input clk, reset, en;
   output [7:0] count;
   
   reg [7:0] count;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         count <= 8'b0;
      else if (en)
         count <= count + 1;
   end
   
endmodule