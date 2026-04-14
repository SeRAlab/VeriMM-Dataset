module top_module(
  input [31:0] data,
  input clock,
  input clk_en,
  input cnt_en,
  input aset,
  input sload,
  output reg [31:0] q
);always @ (posedge clock) begin
    if (aset) begin
      q <= 0;
    end else if (sload) begin
      q <= data;
    end else if (cnt_en && clk_en) begin
      q <= q + 1;
    end
  end

endmodule