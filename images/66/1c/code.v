module top_module(
  input clk,
  input rst,
  output reg [3:0] count
);always @(posedge clk) begin
    if (rst) begin
      count <= 4'h0;
    end else if (count == 4'h9) begin
      count <= 4'h0;
    end else begin
      count <= count + 1;
    end
  end

endmodule