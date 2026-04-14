module clock_gate (
  input clk,
  input en,
  input te,
  output reg en_clk
);

  always @(posedge clk) begin
    if (en && te) begin
      en_clk <= 1'b1;
    end else begin
      en_clk <= 1'b0;
    end
  end

endmodule