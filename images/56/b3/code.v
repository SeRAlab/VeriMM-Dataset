module top_module(
   input [15:0] data_in,
   output reg [3:0] data_out
   );always @*
   begin
      data_out = data_in[15:12];
   end

endmodule