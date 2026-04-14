module top_module(
  input D,
  input G,
  input SN,
  output reg Q,    // Changed to output reg
  output reg QN    // Changed to output reg
);always @(posedge G or negedge SN) begin
  if (!SN) begin
    Q <= 1'b0;
    QN <= 1'b1;
  end else begin
    Q <= D;
    QN <= ~D;
  end
end

endmodule