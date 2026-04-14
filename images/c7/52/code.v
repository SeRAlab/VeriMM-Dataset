module d_ff_ar (
  input clk,
  input ar,
  input D,
  output reg Q
);

  always @(posedge clk, negedge ar) begin
    if (!ar) begin
      Q <= 1'b0;
    end else begin
      Q <= D;
    end
  end

endmodule
