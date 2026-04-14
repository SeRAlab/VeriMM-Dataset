module top_module(
  input [n-1:0] data_in,
  input [n-1:0] checksum_in,
  output reg valid_data
);parameter n = 8; // number of data signals

wire signed [n+1:0] sum;
wire signed [n+1:0] twos_complement;
wire signed [n+1:0] checksum_calc;

assign sum = {1'b0, data_in} + checksum_in;
assign twos_complement = ~sum + 1;
assign checksum_calc = {1'b0, data_in} + twos_complement;

assign checksum_out = twos_complement;

always @(*) begin
  if (checksum_calc == checksum_in) begin
    valid_data = 1'b1;
  end else begin
    valid_data = 1'b0;
  end
end

endmodule