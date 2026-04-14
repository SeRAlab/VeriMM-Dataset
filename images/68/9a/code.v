module top_module(
  input clk, // 10 ns clock
  input rst_n, // synchronous reset (active low)
  input en, // enable input
  output reg [3:0] count // 4-bit output port
);always @(posedge clk) begin
    if (!rst_n) begin
      count <= 4'b0000; // reset to 0
    end else if (en) begin
      if (count == 4'b1111) begin
        count <= 4'b0000; // reset to 0
      end else begin
        count <= count + 1; // increment count
      end
    end
  end

endmodule