module top_module(
  input clk,
  input rst,
  input [7:0] div,
  output reg [width-1:0] out
);parameter width = 8; // width of the output signal

reg [7:0] count;
reg toggle;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    count <= 0;
    out <= 0;
    toggle <= 0;
  end else begin
    count <= count + 1;
    if (count == div) begin
      toggle <= ~toggle;
      count <= 0;
    end
    out <= toggle;
  end
end

endmodule