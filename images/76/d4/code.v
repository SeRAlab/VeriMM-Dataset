module top_module(
  input clk,
  input rst,
  input en,
  output reg [3:0] count,
  output reg overflow
);always @(posedge clk) begin
    if (rst) begin
      count <= 4'b0;
      overflow <= 1'b0;
    end else if (en) begin
      if (count == 4'hF) begin
        count <= 4'b0;
        overflow <= 1'b1;
      end else begin
        count <= count + 1;
        overflow <= 1'b0;
      end
    end
  end

endmodule