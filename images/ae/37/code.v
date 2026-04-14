module top_module(clk, up_down, reset, count);input clk, up_down, reset;
   output reg [3:0] count;

   always @(posedge clk) begin
      if (reset) begin
         count <= 4'b0000;
      end else begin
         if (up_down) begin
            count <= count + 1;
         end else begin
            count <= count - 1;
         end
      end
   end

endmodule