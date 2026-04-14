module binary_counter_4bit (count, clk, reset, en);
   input clk, reset, en;
   output [3:0] count;
   
   reg [3:0] count;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         count <= 4'b0;
      else if (en)
         count <= count + 1;
   end
   
endmodule