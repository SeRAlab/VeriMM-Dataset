module top_module(
  input clk,
  input rst,
  input en,
  input up_down,
  output reg [n-1:0] count
);parameter n = 4; // number of bits in the counter

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
  end else if (en) begin
    if (up_down) begin
      count <= count + 1;
    end else begin
      count <= count - 1;
    end
  end
end

endmodule