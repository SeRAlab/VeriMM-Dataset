module top_module(
  input clk,
  input rst,
  input en,
  input up,
  input down,
  output reg [3:0] count
);always @(posedge clk) begin
    if (rst) begin
      count <= 4'b0;
    end else if (en) begin
      if (up) begin
        count <= count + 1;
      end else if (down) begin
        count <= count - 1;
      end
    end
  end

endmodule