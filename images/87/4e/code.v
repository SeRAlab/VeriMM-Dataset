module top_module(
  input clk,
  input rst,
  output reg [3:0] count,
  output reg out_range
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      count <= 4'b0000;
      out_range <= 1'b0;
    end else begin
      if (count == 4'b1010) begin
        out_range <= 1'b1;
      end else if (count == 4'b1111) begin
        count <= 4'b0000;
        out_range <= 1'b0;
      end else begin
        out_range <= 1'b0;
      end
      count <= count + 1;
    end
  end

endmodule