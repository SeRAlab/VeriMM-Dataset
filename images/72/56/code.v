module dff_en (
  input clk,
  input en,
  input D,
  output reg Q);always @(posedge clk) begin
  if (en)
    Q <= D;
end

endmodule