module top_module(clk, reset, count);input clk, reset;
  output reg [3:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0;
    end else if (count == 4'b1111) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end
endmodule