module top_module(
   input clk,
   input rst,
   input inc,
   input dec,
   output reg [3:0] cnt
);always @(posedge clk) begin
      if (rst) begin
         cnt <= 0;
      end
      else if (inc && !dec) begin
         if (cnt == 15) begin
            cnt <= 0;
         end
         else begin
            cnt <= cnt + 1;
         end
      end
      else if (dec && !inc) begin
         if (cnt == 0) begin
            cnt <= 15;
         end
         else begin
            cnt <= cnt - 1;
         end
      end
   end

endmodule