module top_module(input clk, input reset,
   output reg [3:0] count, output reg max);always @(posedge clk or negedge reset) begin
      if(!reset) begin
         count <= 4'b0;
         max <= 1'b0;
      end else begin
         count <= count + 1;
         if(count == 4'hF) begin
            max <= 1'b1;
         end else begin
            max <= 1'b0;
         end
      end
   end

endmodule