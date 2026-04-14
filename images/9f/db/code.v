module top_module(
 input clk,
 input [15:0] data_in,
 input shift_control,
 output reg [15:0] data_out
);always @(posedge clk) begin
   if (shift_control == 1'b1) begin
     data_out <= {data_in[14:0], 1'b0};
   end else begin
     data_out <= data_in;
   end
 end
endmodule