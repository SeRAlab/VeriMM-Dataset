module top_module(
  clk,
  reset,
  data_in,
  data_in_valid,
  data_out,
  data_out_ack
);input   clk;
input   reset;
input [7:0]  data_in;
input   data_in_valid;
output [7:0]  data_out;
output  data_out_ack;

reg [7:0]  data_out;
reg   data_out_ack;

always @ (posedge clk)
if (reset) begin
   data_out <= 0;
   data_out_ack <= 0;
end else if (data_in_valid) begin
   data_out <= data_in;
   data_out_ack <= 1;
end else begin
   data_out <= 0;
   data_out_ack <= 0;
end

endmodule