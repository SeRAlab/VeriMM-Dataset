module top_module(
  input clk,
  input data,
  output reg out
);reg q1, q2;

always @(posedge clk) begin
  q1 <= data;
end

always @(negedge clk) begin
  q2 <= q1;
end

always @(posedge clk) begin
  q1 <= q2;
end

assign out = q2;

endmodule