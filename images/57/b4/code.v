module top_module(
  input clk,
  input reset,
  output reg [3:0] count
);reg [3:0] next_count;

  always @(posedge clk) begin
    if (reset) begin
      next_count <= 4'b0000;
    end
    else begin
      next_count <= count + 1;
    end
  end

  assign count = next_count;

endmodule