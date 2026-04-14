module top_module(clk, reset, count);input clk, reset;
   output reg [3:0] count;
   
   always @(posedge clk or negedge reset) begin
      if (reset == 0) begin
         count <= 0;
      end else begin
         count <= count + 1;
      end
   end

endmodule