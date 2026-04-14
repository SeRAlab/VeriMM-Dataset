module top_module(
   input         clk, reset, enable, load,
   input  [3:0]  data_in,
   output [3:0]  data_out);reg [3:0] counter;

   always @(posedge clk) begin
      if (reset) begin
         counter <= 4'b0;
      end else if (enable) begin
         if (load) begin
            counter <= data_in;
         end else begin
            counter <= counter + 1;
         end
      end
   end

   assign data_out = counter;

endmodule