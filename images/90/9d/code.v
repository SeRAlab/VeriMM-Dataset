module top_module(
  input clk,
  input rst,
  input dir,
  output reg [n-1:0] out
);parameter n = 4; // number of binary digits in the counter

reg [n-1:0] count;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    count <= 0;
  end else if (dir) begin
    count <= count + 1;
  end else begin
    count <= count - 1;
  end
end

assign out = count;

endmodule