module max_val_module(
  input clk,
  input [15:0] in,
  output reg [15:0] max_val
);

  always @(posedge clk) begin
    if (in > max_val) begin
      max_val <= in;
    end
  end

endmodule