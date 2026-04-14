module top_module(clk, reset, count);input clk, reset;
  output reg [1:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 2'b0;
    end else begin
      if (count == 2'b11) begin
        count <= 2'b0; // Wrap around from 3 to 0
      end else begin
        count <= count + 1;
      end
    end
  end
endmodule