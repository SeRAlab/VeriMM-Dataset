module top_module(input clk, reset, enable, load,
   input [31:0] load_value,
   output reg [31:0] count);always @(posedge clk) begin
      if (reset) begin
         count <= 0;
      end else if (load) begin
         count <= load_value;
      end else if (enable) begin
         count <= count + 1;
      end
   end
   
endmodule