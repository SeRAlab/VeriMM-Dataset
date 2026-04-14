module top_module(
  input clk,
  input rst,
  input [7:0] timeout,
  output reg wdout
);reg [7:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
      wdout <= 0;
    end else begin
      count <= count + 1;
      if (count >= timeout) begin
        wdout <= 1;
      end else begin
        wdout <= 0;
      end
    end
  end

  always @(posedge clk) begin
    if (wdout) begin
      count <= 0;
    end
  end

endmodule