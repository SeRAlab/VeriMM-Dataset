module top_module(
  input [15:0] data_in,
  input enable,
  output reg [15:0] data_out
);parameter MASK_VALUE = 16'hABCD;

  always @(posedge enable) begin
    if (enable) begin
      data_out = data_in & MASK_VALUE;
    end else begin
      data_out = 16'b0;
    end
  end

endmodule