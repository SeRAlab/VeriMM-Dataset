module top_module(
  input clk,
  input [3:0] in,
  output reg [2:0] count
);reg [2:0] prev_count;

always @(posedge clk) begin
  prev_count <= count;
  count <= prev_count;
  if (in[0] == 1) begin
    count <= count + 1;
  end
  if (in[1] == 1) begin
    count <= count + 1;
  end
  if (in[2] == 1) begin
    count <= count + 1;
  end
  if (in[3] == 1) begin
    count <= count + 1;
  end
end

endmodule