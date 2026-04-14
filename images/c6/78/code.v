module accumulator (
  input clk, rst,
  input [7:0] data_in,
  output [7:0] out
);

reg [7:0] sum;

always @(posedge clk) begin
  if (rst) begin
    sum <= 8'b0;
  end else begin
    sum <= sum + data_in;
  end
end

assign out = sum;

endmodule