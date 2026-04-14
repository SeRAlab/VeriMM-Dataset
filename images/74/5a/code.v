module top_module(
  input clk,
  input [3:0] reset,
  input [3:0] enable,
  output reg [3:0] count
);always @(posedge clk) begin
  if (reset == 4'b1111) begin
    count <= 4'b0000;
  end else if (enable == 4'b1111) begin
    count <= count + 1;
    if (count == 4'b1111) begin
      count <= 4'b0000;
    end
  end
end

endmodule