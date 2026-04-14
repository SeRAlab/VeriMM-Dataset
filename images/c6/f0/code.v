module sysgen_constant (
  output reg op,
  input clk,
  input ce,
  input clr
);

  always @(posedge clk) begin
    if (clr) begin
      op <= 1'b0;
    end else if (ce) begin
      op <= 1'b0;
    end
  end

endmodule