module counter(
  input clk,
  input reset,
  output [3:0] count
);

reg [3:0] count_reg;

always @(posedge clk) begin
  if (reset) begin
    count_reg <= 4'b0000;
  end else begin
    count_reg <= count_reg + 1;
  end
end

assign count = count_reg;

endmodule


module counter_top(
  input clk,
  input reset,
  output reg [4:0] count
);

wire [3:0] count1, count2;

counter c1(
  .clk(clk),
  .reset(reset),
  .count(count1)
);

counter c2(
  .clk(clk),
  .reset(reset),
  .count(count2)
);

always @(posedge clk) begin
  count <= count1 + count2;
end

endmodule