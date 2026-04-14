module top_module(
  input clk,
  input rst,
  output reg [3:0] count
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      count <= 4'b0000;
    end else begin
      count <= count + 1;
    end
  end

endmodule