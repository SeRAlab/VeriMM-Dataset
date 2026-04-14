module top_module(
  input clk,
  input rst,
  output reg clk_out
);parameter div = 2;
reg [31:0] count;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    clk_out <= 1'b0;
    count <= 0;
  end
  else begin
    if (count == div - 1) begin
      clk_out <= ~clk_out;
      count <= 0;
    end
    else begin
      count <= count + 1;
    end
  end
end

endmodule